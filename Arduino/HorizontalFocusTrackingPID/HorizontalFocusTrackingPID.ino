

#include <SPI.h>
#include <Wire.h>  

#include <TeensyTimerTool.h>
using namespace TeensyTimerTool;
#include <Audio.h>
#include <utility/imxrt_hw.h>

#include "Adafruit_GFX.h"
#include "Adafruit_ILI9341.h"
#include <XPT2046_Touchscreen.h>

#define CS_PIN  17


// MOSI=11, MISO=12, SCK=13

XPT2046_Touchscreen ts(CS_PIN);
//#define TIRQ_PIN  2
//XPT2046_Touchscreen ts(CS_PIN);  // Param 2 - NULL - No interrupts
//XPT2046_Touchscreen ts(CS_PIN, 255);  // Param 2 - 255 - No interrupts
//XPT2046_Touchscreen ts(CS_PIN, TIRQ_PIN);  // Param 2 - Touch IRQ Pin - interrupt enabled polling

#define TFT_DC 10
#define TFT_CS 16
#define TFT_MOSI 11
#define TFT_CLK 13
#define TFT_RST 255
#define TFT_MISO 12
Adafruit_ILI9341 tft = Adafruit_ILI9341(TFT_CS, TFT_DC, TFT_MOSI, TFT_CLK, TFT_RST, TFT_MISO);
//Adafruit_ILI9341 tft = Adafruit_ILI9341(TFT_CS, TFT_DC);


/*
#include <Wire.h>
#include <SPI.h>
#include <SD.h>
#include <SerialFlash.h>
#include <Bounce.h>
*/

//AudioPlaySdWav           playSdWav1;
AudioOutputI2S           i2s1;
//usb audio not working, sample rate can not be modified easily.
//AudioOutputUSB           usb_out; // must set Tools > USB Type to Audio

AudioPlayQueue       Left_audio;
AudioPlayQueue       Right_audio;
AudioConnection          patchCord1(Left_audio, 0, i2s1, 1);
AudioConnection          patchCord2(Right_audio, 0, i2s1, 0);

//AudioConnection          patchCord1(Left_audio, 0, usb_out, 0);
//AudioConnection          patchCord2(Right_audio, 0, usb_out, 1);

AudioControlSGTL5000     sgtl5000_1;


// Use these with the Teensy Audio Shield
//#define SDCARD_CS_PIN    10
//#define SDCARD_MOSI_PIN  7
//#define SDCARD_SCK_PIN   14

#define LSYNC_PIN_R 0
#define LSYNC_PIN_F 1
#define RSYNC_PIN_R 2
#define RSYNC_PIN_F 3
#define SIG_PIN_R 4
#define SIG_PIN_F 5

#define GROOVE_TRACK_PIN_P 6
#define GROOVE_TRACK_PIN_N 9
#define GROOVE_TRACK_COARSE 14


#define MIRR_CLK 22



 

#define SIG_BUFF_LEN 32 //maximum number of edges in on scan
#define SIG_BUFF_MASK 0x1f //not used, SIG_BUFF_LEN is adequate

#define SAMPLE_RATE 44100 //not used
#define MIRR_FREQ_DEFAULT 13700
#define POS_A_DEFAULT  MIRR_FREQ_DEFAULT/10000
#define POS_B_DEFAULT  (MIRR_FREQ_DEFAULT % 10000)/1000
#define POS_C_DEFAULT  (MIRR_FREQ_DEFAULT % 10000 % 1000)/100
#define POS_D_DEFAULT  (MIRR_FREQ_DEFAULT % 10000 % 1000 % 100)/10
#define POS_E_DEFAULT  (MIRR_FREQ_DEFAULT % 10000 % 1000 % 100 % 10 )

#define BLOCK_SIZE 128
//porportion range -65535 to 65535, step 1
//differential range -12383 to 12383, step 1
//integral range -16777216 to 16777216, step 1
//everything is devided by 2^k_shift
//controller range, full int range, clip at + - 256 (15N)
/*
int AVG_len = 8;
int Kp = 800;    
int Kd = 50;
int Ki = 18;    
int K_shift = 23;
*/
int AVG_len = 512;
int  Kp = 10;      
int Kd = 350;
int Ki = 12;    
int  K_shift = 22;


#define T_Bias 0

/*
#define AVG_len 512
#define Kp 8     // spring is 10N 1mm, max trackable range is +-1.5mm with 1/4 deviation, need to /64 
#define Kd 350
#define Ki 12    // reducing 1/4 (16384) deviation steady state in 64 samples  need to /4096
#define K_shift 22
#define T_Bias 0
*/

/*
#define AVG_len 8
#define Kp 800    // spring is 10N 1mm, max trackable range is +-1.5mm with 1/4 deviation, need to /64 
#define Kd 50
#define Ki 18    // reducing 1/4 (16384) deviation steady state in 64 samples  need to /4096
#define K_shift 22
#define T_Bias 0
*/

#define MAX_SKIP 200
/*
#define ML_Bias  400
#define MR_Bias  700
*/

#define ML_Bias  -150
#define MR_Bias  -70
//initial maximum Groove Width

uint32_t Groove_Width = 3000;
uint32_t Max_Jump = 1000;

//time frame estimation from SYNC
uint32_t lsync_rise_frame;
//uint32_t lsync_rise_frame_l;
uint32_t lsync_fall_frame;
volatile uint32_t lsync_start_frame = 0;
volatile uint32_t lsync_start_raw;
//uint32_t lsync_end_frame;
uint32_t lsync_width;
volatile bool lsync_done;
uint32_t rsync_rise_frame;
uint32_t rsync_fall_frame;
volatile uint32_t rsync_start_frame = 0;
volatile uint32_t rsync_start_raw;
//uint32_t rsync_end_frame;
uint32_t rsync_width;
volatile bool rsync_done;

//groove tracking data
int Track_Array[512] = {0};
int Track_Sum = 0;
uint16_t Tracking_RC = 0;
uint16_t Track_Pointer = 0;


uint8_t  lsync_counts;
uint8_t  rsync_counts;

//raw SIG data
uint32_t  MIRROR_FREQ;
uint32_t MIRR_FREQ = MIRR_FREQ_DEFAULT;
uint32_t  MIRROR_TIME;

volatile uint32_t SIG_LTR[SIG_BUFF_LEN];
volatile uint32_t SIG_LTR_R[SIG_BUFF_LEN];
volatile uint8_t SIG_LTR_i;
volatile uint32_t SIG_RTL[SIG_BUFF_LEN];
volatile uint32_t SIG_RTL_R[SIG_BUFF_LEN];
volatile uint8_t SIG_RTL_i;

//used for estimation cecnter of groove
#define Audio_Avg_Len 1024
uint32_t SIG_L_last, SIG_R_last;
uint32_t SIG_L_list[Audio_Avg_Len]={0};
uint32_t SIG_R_list[Audio_Avg_Len]={0};
uint32_t  SIG_L_Sum, SIG_R_Sum;
uint32_t  SIG_L_pre, SIG_R_pre;
uint16_t Audio_RC = 0;
uint32_t SIG_L_last_RTL, SIG_R_last_LTR;
int32_t SIG_L_change, SIG_R_change;
uint32_t SIG_L_min, SIG_R_min;
volatile uint8_t SIG_L_index, SIG_R_index;
volatile bool NO_SIG_L;
volatile bool NO_SIG_R;

uint32_t NO_SIG_L_count = 0;
uint32_t NO_SIG_R_count = 0;
uint32_t NO_SIG_L_count_l = 0;
uint32_t NO_SIG_R_count_l = 0;

uint8_t SIG_RTL_i_b = 100;
uint8_t SIG_LTR_i_b  = 100;

uint8_t DIR_LTR;
uint32_t Time_Reader_r;
uint32_t Time_Reader_f;
uint8_t tmp;
int16_t* L_Audio_p;
int16_t* R_Audio_p;
int32_t L_Audio_Data;
int32_t R_Audio_Data;
int32_t L_Audio_Data_l;
int32_t R_Audio_Data_l;
int32_t L_Audio_Data_dl, L_Audio_Data_d, R_Audio_Data_dl, R_Audio_Data_d;
int32_t  L_Audio_Denoise,  R_Audio_Denoise;
//int16_t UpSample_Buff_L[BLOCK_SIZE];
//int16_t UpSample_Buff_R[BLOCK_SIZE];
int16_t* UpSample_Buff_L;
int16_t* UpSample_Buff_R;
uint8_t UpSample_Buff_RC_L, UpSample_Buff_RC_R;
uint8_t nulls;

//maximum extrapolation length = 8 samples
int Denoise_L_Audio[8] = {0};
int Denoise_R_Audio[8] = {0};
uint8_t Denoise_RC = 0;
uint8_t Denoise_Len = 0;
int Denoise_Slop = 0;
#define Denoise_Mask 0x7 

uint32_t lsync_start_local;
uint32_t rsync_start_local;

uint32_t split_sync;

int16_t test_audio_speed = 0;

bool New_Control_Data = 0;
int G_Tracking_Error = 0;
int G_Tracking_Force = 0;
int G_Tracking_Error_l = 0;
//uint8_t G_Tracking_Index = 0;
int G_Tracking_Inti = 0;
int G_Tracking_Diff = 0;
int Coarse_Force = 0;
uint32_t NO_SIG_COUNT = 0;
uint32_t CORRECT_COUNT = 0;

uint32_t skip_count = 0;
uint32_t cycles = 0;

uint32_t Max_Dev = 0;
int16_t L_OUT;
int16_t R_OUT;

float global_volume = 0.7;
float global_bass = -0.5;
float global_treble = 0.6;


bool OUTEDGE = 0;

uint32_t sync_correct = 0;
uint32_t time_analyse = 0;

bool play_audio = 0;
bool audio_enhancer = 1;

uint32_t STATE_CHECK = 0;
uint8_t PLAY_MODE = 0;
//0:play 1:back 2:forward 3:find next track 4:find previous track 5:reset 6 land

bool AUDIO_ON = 1;
bool CTRL_ON = 1;
bool PAUSE = 0;
bool BACK_PRESSED = 0;
bool FORW_PRESSED = 0;
uint8_t EQ_MODE = 0;

bool start_reset = 0;
uint32_t trough_count = 0;
bool IN_SONG = 1;
uint32_t in_song_count = 0;

volatile bool CLEAR_LTR = 1;
volatile bool CLEAR_RTL = 1;

bool DEGLITCH = 1;
uint32_t reset_start = ARM_DWT_CYCCNT;

uint8_t DISC_TYPE = 0;
//0 is vinyl, 1 is shellac inner, 2 is shellac outer
bool FEEDBACK_DRIVE = 0;

//setI2SFreq is written by FrankB at forum.pjrc.com
void setI2SFreq(int freq) {
  // PLL between 27*24 = 648MHz und 54*24=1296MHz
  int n1 = 4; //SAI prescaler 4 => (n1*n2) = multiple of 4
  int n2 = 1 + (24000000 * 27) / (freq * 256 * n1);
  double C = ((double)freq * 256 * n1 * n2) / 24000000;
  int c0 = C;
  int c2 = 10000;
  int c1 = C * c2 - (c0 * c2);
  set_audioClock(c0, c1, c2, true);
  CCM_CS1CDR = (CCM_CS1CDR & ~(CCM_CS1CDR_SAI1_CLK_PRED_MASK | CCM_CS1CDR_SAI1_CLK_PODF_MASK))
       | CCM_CS1CDR_SAI1_CLK_PRED(n1-1) // &0x07
       | CCM_CS1CDR_SAI1_CLK_PODF(n2-1); // &0x3f 
//Serial.printf("SetI2SFreq(%d)\n",freq);
}

void RESET_CTRL()
{       analogWrite(GROOVE_TRACK_COARSE, 116 );
        analogWrite(GROOVE_TRACK_PIN_P, 0);
        analogWrite(GROOVE_TRACK_PIN_N, 0);
        Track_Sum = 0;
        NO_SIG_COUNT = 0;
        G_Tracking_Inti = 0;
        Groove_Width = 4000;
        SIG_L_last = MIRROR_TIME / 2;
        SIG_R_last = MIRROR_TIME / 2;
        SIG_L_Sum =(MIRROR_TIME / 2) * Audio_Avg_Len ;
        SIG_R_Sum =(MIRROR_TIME / 2) * Audio_Avg_Len ;

        SIG_L_pre = SIG_L_last ;
        SIG_R_pre = SIG_R_last ;
        for (int i=0; i<Audio_Avg_Len; i++)
        {
           SIG_L_list[i]=MIRROR_TIME / 2;
           SIG_R_list[i]=MIRROR_TIME / 2;
        }
        Max_Jump = 2000;
        CORRECT_COUNT = 0;
}

void UpSample_irq() {
 // play_audio = 1;
 /*
  sei();//to avoid missing GPIO interrupts
 // test_audio_speed += 128; //saw tooth test
  if (UpSample_Buff_RC == AUDIO_BLOCK_SAMPLES)
  {
    UpSample_Buff_RC = 0;
    
  }

  UpSample_Buff_R[UpSample_Buff_RC] = R_OUT;
  UpSample_Buff_L[UpSample_Buff_RC] = L_OUT;
  UpSample_Buff_RC += 1;
 */
}

#define PLAY_PAUSE_X 128
#define PLAY_PAUSE_Y 176
#define NEXT_X 256
#define NEXT_Y 176
#define PREV_X 0
#define PREV_Y 176
#define BACK_X 64
#define BACK_Y 176
#define FORW_X 192
#define FORW_Y 176
#define VOL_X 256
#define VOL_Y 60

#define LAND_X 0
#define LAND_Y 120
#define EDGE_X 0
#define EDGE_Y 60
#define RST_X 0
#define RST_Y 0
#define EQ_X 256
#define EQ_Y 0

uint8_t Lines_i_l = 0;
uint8_t Lines_i = 0;
uint16_t Lines_Val[32];
uint16_t Lines_Val_l[32];
bool DRAWN = 0;

bool MIRR_CLK_STA = 0;

void Write_Nm()
{ tft.SPI_Init();
  tft.setTextColor(ILI9341_WHITE);
  tft.setTextSize(3);
  tft.setCursor(192,40);
  tft.print("um");
}

#define SCAN_SCALE 100
#define GROOVE_WIDTH_MAX 8000
void Write_Groove_Width()
{
  tft.SPI_Init();
  tft.fillRect(128,40,64,56,ILI9341_BLACK);
  tft.setTextSize(3);
  tft.setCursor(128,40);
  
  if((PLAY_MODE == 0))
  { if(!DISC_TYPE){
    uint8_t GREEN_VAL = (GROOVE_WIDTH_MAX - Groove_Width)/(GROOVE_WIDTH_MAX / 64 + 1);
    uint8_t RED_VAL =  Groove_Width/((GROOVE_WIDTH_MAX / 32)+1);
    tft.setTextColor((GREEN_VAL<<5) + (RED_VAL<<11));
    tft.print(Groove_Width / SCAN_SCALE);
    }
    else
    {
      tft.setTextColor(ILI9341_GREEN);
      tft.print("---");
    }
    
  }

  else
  { tft.setTextColor(ILI9341_RED);
    tft.print("---");
  }
}

void Draw_Eq(char input_char)
{ tft.SPI_Init();
  tft.fillRect(EQ_X,EQ_Y,64,56,ILI9341_BLACK);
  tft.drawRect(EQ_X+8,EQ_Y+4,48,48,ILI9341_WHITE);
  tft.setTextColor(ILI9341_WHITE);
  tft.setTextSize(3);
  tft.setCursor(EQ_X+23,EQ_Y+18);
  tft.print(input_char);
}

void Draw_Reset(uint16_t color_in)
{ tft.SPI_Init();
  tft.fillRect(RST_X,RST_Y,64,56,ILI9341_BLACK);
  tft.drawRect(RST_X+8,RST_Y+4,48,48,color_in);
  tft.setTextColor(color_in);
  tft.setTextSize(3);
  tft.setCursor(RST_X+8,RST_Y+18);
  tft.print(" X ");
}

void Draw_Land(uint16_t color_in)
{ tft.SPI_Init();
  tft.fillRect(LAND_X,LAND_Y,64,56,ILI9341_BLACK);
  tft.drawRect(LAND_X+8,LAND_Y+4,48,48,color_in);
  tft.setTextColor(color_in);
  tft.setTextSize(3);
  tft.setCursor(LAND_X+8,LAND_Y+18);
  tft.print("->|");
}


void Draw_Edge(uint16_t color_in)
{ tft.SPI_Init();
  tft.fillRect(EDGE_X,EDGE_Y,64,56,ILI9341_BLACK);
  tft.drawRect(EDGE_X+8,EDGE_Y+4,48,48,color_in);
  tft.setTextColor(color_in);
  tft.setTextSize(3);
  tft.setCursor(EDGE_X+8,EDGE_Y+18);
  tft.print("|<-");
  
}

void Draw_Vol(float vol_in){
 tft.SPI_Init();
 uint16_t Vol_Height = (uint16_t)(vol_in * (float)112);
 tft.drawRect(VOL_X+8,VOL_Y+4,48,112,ILI9341_WHITE);
 tft.fillRect(VOL_X+20,VOL_Y+4,24,112,0x7AEF);
 tft.fillRect(VOL_X+20,VOL_Y+116-Vol_Height,24,Vol_Height,ILI9341_WHITE);
}

void Draw_Forw(uint16_t color_in){
   tft.SPI_Init();
   tft.fillRect(FORW_X,FORW_Y,64,64,ILI9341_BLACK);
   tft.fillTriangle(FORW_X+14,FORW_Y+50,FORW_X+14,FORW_Y+14,FORW_X+42,FORW_Y+32,color_in);
   tft.fillTriangle(FORW_X+26,FORW_Y+50,FORW_X+26,FORW_Y+14,FORW_X+54,FORW_Y+32,color_in);
}

void Draw_Back(uint16_t color_in){
   tft.SPI_Init();
   tft.fillRect(BACK_X,BACK_Y,64,64,ILI9341_BLACK);
   tft.fillTriangle(BACK_X+22,BACK_Y+32,BACK_X+50,BACK_Y+14,BACK_X+50,BACK_Y+50,color_in);
   tft.fillTriangle(BACK_X+10,BACK_Y+32,BACK_X+38,BACK_Y+14,BACK_X+38,BACK_Y+50,color_in);
}


void Draw_Prev(uint16_t color_in){
   tft.SPI_Init();
   tft.fillRect(PREV_X,PREV_Y,64,64,ILI9341_BLACK);
   tft.fillTriangle(PREV_X+22,PREV_Y+32,PREV_X+50,PREV_Y+14,PREV_X+50,PREV_Y+50,color_in);
   tft.fillRect(PREV_X+22,PREV_Y+14,6,36,color_in);
}
void Draw_Next(uint16_t color_in){
   tft.SPI_Init();
   tft.fillRect(NEXT_X,NEXT_Y,64,64,ILI9341_BLACK);
   tft.fillTriangle(NEXT_X+14,NEXT_Y+50,NEXT_X+14,NEXT_Y+14,NEXT_X+42,NEXT_Y+32,color_in);
   tft.fillRect(NEXT_X+42,NEXT_Y+14,6,36,color_in);
}

void Draw_Play(uint16_t color_in){
   tft.SPI_Init();
   tft.fillRect(PLAY_PAUSE_X,PLAY_PAUSE_Y,64,64,ILI9341_BLACK);
   tft.fillTriangle(PLAY_PAUSE_X+14,PLAY_PAUSE_Y+50,PLAY_PAUSE_X+14,PLAY_PAUSE_Y+14,PLAY_PAUSE_X+50,PLAY_PAUSE_Y+32,color_in);
}
void Draw_Pause(uint16_t color_in){
   tft.SPI_Init();
   tft.fillRect(PLAY_PAUSE_X,PLAY_PAUSE_Y,64,64,ILI9341_BLACK);
   tft.fillRect(PLAY_PAUSE_X+24,PLAY_PAUSE_Y+14,6,36,color_in);
   tft.fillRect(PLAY_PAUSE_X+38,PLAY_PAUSE_Y+14,6,36,color_in);
}

uint8_t POS_A = POS_A_DEFAULT;
uint8_t POS_B = POS_B_DEFAULT;
uint8_t POS_C = POS_C_DEFAULT;
uint8_t POS_D = POS_D_DEFAULT;
uint8_t POS_E = POS_E_DEFAULT;


void Draw_Key_Pad(){
   tft.drawRect(199,96,50,40,ILI9341_BLUE);
   tft.setCursor(203, 110);
   tft.setTextSize(2);
   tft.setTextColor(ILI9341_BLUE);
   tft.print("Set");
   tft.drawRect(263,96,50,40,ILI9341_GREEN);
   tft.setCursor(271, 110);
   tft.setTextSize(2);
   tft.setTextColor(ILI9341_GREEN);
   tft.print("Go");
   tft.setTextColor(ILI9341_WHITE);
    tft.setTextSize(2);
   tft.drawRect(7,144,50,40,ILI9341_WHITE);
   tft.setCursor(28, 158);
   tft.print("0");
   tft.drawRect(71,144,50,40,ILI9341_WHITE);
   tft.setCursor(92, 158);
   tft.print("1");
   tft.drawRect(135,144,50,40,ILI9341_WHITE);
   tft.setCursor(156, 158);
   tft.print("2");
   tft.drawRect(199,144,50,40,ILI9341_WHITE);
   tft.setCursor(220, 158);
   tft.print("3");
   tft.drawRect(263,144,50,40,ILI9341_WHITE);
   tft.setCursor(284, 158);
   tft.print("4");
   tft.drawRect(7,192,50,40,ILI9341_WHITE);
   tft.setCursor(28, 206);
   tft.print("5");
   tft.drawRect(71,192,50,40,ILI9341_WHITE);
   tft.setCursor(92, 206);
   tft.print("6");
   tft.drawRect(135,192,50,40,ILI9341_WHITE);
    tft.setCursor(156, 206);
   tft.print("7");
   tft.drawRect(199,192,50,40,ILI9341_WHITE);
    tft.setCursor(220, 206);
   tft.print("8");
   tft.drawRect(263,192,50,40,ILI9341_WHITE);
    tft.setCursor(284, 206);
   tft.print("9");

   
}
void Set_Mirr_Freq(){
   FEEDBACK_DRIVE = 0;
   analogWriteFrequency(MIRR_CLK, MIRR_FREQ);
   analogWrite(MIRR_CLK, 128);
   tft.SPI_Init();
   tft.fillScreen(ILI9341_BLACK);
   tft.setTextColor(ILI9341_WHITE);
   tft.setTextSize(3);
   tft.setCursor(20, 10);
   tft.print("Set Mirror Freq");
   Draw_Key_Pad();
   tft.setTextColor(ILI9341_WHITE);
   tft.setTextSize(2);
   tft.setCursor(20, 96);
   tft.print("Freq:");
   tft.fillRect(80, 96, 112,40,ILI9341_BLACK);
   tft.setCursor(80, 96);
   tft.print(POS_A);
   tft.setCursor(102, 96);
   tft.print(POS_B);
   tft.setCursor(124, 96);
   tft.print(POS_C);
   tft.setCursor(146, 96);
   tft.print(POS_D);
   tft.setCursor(168, 96);
   tft.print(POS_E);

   tft.setCursor(20, 48);
   tft.print("Lsync:");
   tft.setCursor(170, 48);
   tft.print("Rsync:");


   
   
   bool finish_set = 0;
   uint8_t update_display_count = 0;
   bool wastouched = 0;
   uint8_t pos_count = 0;
   bool toggle_color = 0;

   while(!finish_set){
    
    lsync_width = 0;
    lsync_counts = 0;
    rsync_counts = 0;
  
    uint32_t time_out = 0;
    uint32_t start_time = ARM_DWT_CYCCNT;
    uint8_t key_val = 0;
    while (lsync_counts < 10 && time_out < 1000000)
    {
      
      if (lsync_done == 1) {
  
        lsync_width += (lsync_fall_frame - lsync_rise_frame);
        lsync_counts++;
        lsync_done = 0;
        digitalWrite(28, 1);
      }
      else
      {
        digitalWriteFast(28, 0);
        time_out ++;
      }
    }

      time_out = 0;
      while ((rsync_counts < 10) && (time_out < 1000000)) {
        if (rsync_done == 1) {
    
          rsync_width += (rsync_fall_frame - rsync_rise_frame);
    
          rsync_counts++;
          rsync_done = 0;
          digitalWrite(28, 1);
        }
        else
        {
          digitalWriteFast(28, 0);
          time_out ++;
        }
      }
    
    
      lsync_width = lsync_width / 10;
      rsync_width = rsync_width / 10;


    update_display_count++;
    if((update_display_count & 0x3) == 0x3)
    {  
       tft.SPI_Init();
       tft.fillRect(90, 48, 80,48,ILI9341_BLACK);
       tft.setCursor(90, 48);
       tft.setTextColor(ILI9341_WHITE);
       tft.print(lsync_width);
       tft.fillRect(240, 48, 80,48,ILI9341_BLACK);
       tft.setCursor(240, 48);
       tft.print(rsync_width);
       if((update_display_count & 0xf) == 0xf){
        toggle_color = !toggle_color;
        tft.setTextColor(ILI9341_WHITE * toggle_color);
      
        switch(pos_count){
              case 0:
                 tft.setCursor(80, 96);
                 tft.print(POS_A);
                 tft.setTextColor(ILI9341_WHITE);
                 tft.setCursor(168, 96);
                 tft.print(POS_E);
              break;
              case 1:
                 tft.setCursor(102, 96);
                 tft.print(POS_B);
                 tft.setTextColor(ILI9341_WHITE);
                 tft.setCursor(80, 96);
                 tft.print(POS_A);
              break;
              case 2:
                 tft.setCursor(124, 96);
                 tft.print(POS_C);
                 tft.setTextColor(ILI9341_WHITE);
                 tft.setCursor(102, 96);
                 tft.print(POS_B);
              break;

              case 3:
                 tft.setCursor(146, 96);
                 tft.print(POS_D);
                 tft.setTextColor(ILI9341_WHITE);
                 tft.setCursor(124, 96);
                 tft.print(POS_C);
              break;

              case 4:
                 tft.setCursor(168, 96);
                 tft.print(POS_E);
                 tft.setTextColor(ILI9341_WHITE);
                 tft.setCursor(146, 96);
                 tft.print(POS_D);
              break;
        }
       }
       ts.begin();
        boolean istouched = ts.touched();
        if (istouched) {
          TS_Point p_raw = ts.getPoint();
          TS_Point p = TS_Point(4095 - p_raw.x, 4095 - p_raw.y, p_raw.z); // flip both axes for 180°

          if (!wastouched) {
             if(p.x > 2290)
             {
              key_val = ((p.x-2290)/755)*5 + p.y/755;
             // Serial.println(key_val);
                tft.SPI_Init();
             switch(pos_count){
              case 0:
              POS_A = key_val;      
               tft.fillRect(80, 96, 22, 40, ILI9341_BLACK);
              pos_count++;
              break;

              case 1:
              POS_B = key_val;
              tft.fillRect(102, 96, 22, 40, ILI9341_BLACK);
              pos_count++;
              break;

              case 2:
              POS_C = key_val;
               tft.fillRect(124, 96, 22, 40, ILI9341_BLACK);
              pos_count++;
              break;

              case 3:
              POS_D = key_val;
               tft.fillRect(146, 96, 22, 40, ILI9341_BLACK);
              pos_count++;
              break;

              case 4:
              POS_E = key_val;
               tft.fillRect(168, 96, 22, 40, ILI9341_BLACK);
              pos_count = 0;
              break;
              
              default:
              pos_count = 0;
              break;
              }
             }
              else if(p.x > 1535)
              {if((p.y/755) == 3)
               {  MIRR_FREQ = 10000 * POS_A + 1000 * POS_B + 100 * POS_C + 10 * POS_D + POS_E;
                  analogWriteFrequency(MIRR_CLK, MIRR_FREQ);
                  analogWrite(MIRR_CLK, 128);
               }
               else if((p.y/755) == 4)
               {  MIRR_FREQ = 10000 * POS_A + 1000 * POS_B + 100 * POS_C + 10 * POS_D + POS_E;
                  analogWriteFrequency(MIRR_CLK, MIRR_FREQ);
                  analogWrite(MIRR_CLK, 128);
                  analogWriteFrequency(GROOVE_TRACK_PIN_P, MIRR_FREQ*2);
                  analogWriteFrequency(GROOVE_TRACK_PIN_N, MIRR_FREQ*2);
                  analogWriteFrequency(GROOVE_TRACK_COARSE,MIRR_FREQ*4);
                  MIRROR_TIME = (uint32_t)((float)300000000 / (float)MIRR_FREQ);
                  delay(2000);
                  FEEDBACK_DRIVE = 1;
                  pinMode(MIRR_CLK, OUTPUT);
                  //digitalWrite(MIRR_CLK, 0);
                  
                  finish_set = 1;
               }
                
              }
           
          }
       
         /* Serial.print(", x = ");
          Serial.print(p.x);
          Serial.print(", y = ");
          Serial.println(p.y);*/
          
        } else {
          if (wastouched) {
           
          }
          //Serial.println("no touch");
        }
        wastouched = istouched;
    }
     delay(20);
   }
   
}

void Draw_GUI(){
    tft.SPI_Init();
 
 // SPI.setFrequency(10000000);
 
  tft.fillScreen(ILI9341_BLACK);
  tft.setTextColor(ILI9341_PINK);
  tft.setTextSize(6);
  //tft.setFont(Arial_60);
  tft.setCursor(20, 80);
  tft.print("Welcome!");

  delay(500);
   tft.SPI_Init();
   tft.fillScreen(ILI9341_BLACK);
   Draw_Play(ILI9341_GREEN);
   //Draw_Pause(ILI9341_YELLOW);
   Draw_Next(ILI9341_BLUE);
   Draw_Prev(ILI9341_BLUE);
   Draw_Back(ILI9341_GREEN);
   Draw_Forw(ILI9341_GREEN);
   Draw_Land(ILI9341_GREEN);
   Draw_Edge(ILI9341_ORANGE);
   Draw_Reset(ILI9341_RED);
   Draw_Eq('V');
   Write_Nm();
   global_volume = 0.7;
   Draw_Vol(global_volume);
  
}

Timer t1(TMR1);

void setup() {
  ARM_DEMCR |= ARM_DEMCR_TRCENA;
  ARM_DWT_CTRL |= ARM_DWT_CTRL_CYCCNTENA;

  NVIC_SET_PRIORITY(IRQ_GPIO6789,0);
  NVIC_SET_PRIORITY(IRQ_QTIMER1,16);
  //NVIC_SET_PRIORITY(IRQ_GPT1,16);
 
 Serial.begin(115200);

  

  pinMode(LSYNC_PIN_R, INPUT_PULLUP);
  pinMode(LSYNC_PIN_F, INPUT_PULLUP);
  pinMode(RSYNC_PIN_R, INPUT_PULLUP);
  pinMode(RSYNC_PIN_F, INPUT_PULLUP);
  pinMode(SIG_PIN_R, INPUT_PULLUP);
  pinMode(SIG_PIN_F, INPUT_PULLUP);

  pinMode(GROOVE_TRACK_PIN_P, OUTPUT);
  pinMode(GROOVE_TRACK_PIN_N, OUTPUT);
  pinMode(GROOVE_TRACK_COARSE, OUTPUT);
  pinMode(MIRR_CLK, OUTPUT);
  pinMode(28, OUTPUT);
  //pinMode(13, OUTPUT);

  SIG_LTR_i = 0;
  SIG_RTL_i = 0;
  DIR_LTR = 0;
  //0 record SIG_RTL[] process SIG_LTR
  //1 wait lsync fall  
  //2 record SIG_LTR[] process SIG_RTL
  //3 wait rsync fall 
  NO_SIG_L = 1;
  NO_SIG_R = 1;
  
      t1.beginOneShot(ProcessAudioControl);
  attachInterrupt(LSYNC_PIN_R, lsync_rise_irq, RISING);
  attachInterrupt(LSYNC_PIN_F, lsync_fall_irq, FALLING);
  attachInterrupt(RSYNC_PIN_R, rsync_rise_irq, RISING);
  attachInterrupt(RSYNC_PIN_F, rsync_fall_irq, FALLING);


  lsync_done = 0;
  lsync_counts = 0;
  rsync_counts = 0;
  MIRROR_FREQ = 0;
  SIG_L_index = 0;
  SIG_R_index = 0;


  ts.begin();
  ts.setRotation(2);

  //  drive mirror with PWM timer. 

 // Serial.println("SSSSSSSSSSSSSSSSSSSSSSS");
   
  SPI.setMOSI(TFT_MOSI);
  SPI.setMISO(TFT_MISO);
  SPI.setSCK(TFT_CLK);
  tft.begin();
  tft.setRotation(3);
  tft.SPI_Init();
  
  sgtl5000_1.enable();
  sgtl5000_1.volume(global_volume);
  
  UpSample_Buff_RC_L = 0;
    UpSample_Buff_RC_R = 0;
  L_Audio_Data = 0;
  R_Audio_Data = 0;
  AudioMemory(128);
  sgtl5000_1.audioPostProcessorEnable();
 /*sgtl5000_1.eqSelect(2);
 sgtl5000_1.eqBands(-0.5, 0.6);*/
 
  sgtl5000_1.eqSelect(3);
  
  
  sgtl5000_1.eqBand(1, -0.6);
  sgtl5000_1.eqBand(2, -0.6);
  sgtl5000_1.eqBand(3, 0.6);
  sgtl5000_1.eqBand(4, 0.7);
  sgtl5000_1.eqBand(5, 1.0);
   
  //115, 300, 990, 3000, 9900 -11.75 to +12dB
  
  Left_audio.setBehaviour(AudioPlayQueue::NON_STALLING);
  Right_audio.setBehaviour(AudioPlayQueue::NON_STALLING);
  UpSample_Buff_L = Left_audio.getBuffer();
  UpSample_Buff_R = Right_audio.getBuffer();
  
//  IntervalTimer *t1 = new IntervalTimer();
//  t1->begin(UpSample_irq, ((1000000.0f ) / (float)(MIRR_FREQ << 1)));

/*  delay(100);
  SPI.setMOSI(SDCARD_MOSI_PIN);
  SPI.setSCK(SDCARD_SCK_PIN);
  if (!(SD.begin(SDCARD_CS_PIN))) {

    Serial.println("Unable to access the SD card");
    delay(500);

  }

*/

 



  analogWriteFrequency(MIRR_CLK, MIRR_FREQ);
  analogWrite(MIRR_CLK, 128);
  analogWriteFrequency(GROOVE_TRACK_COARSE,MIRR_FREQ*4);
 
  ts.begin();
  delay(1000);
 
  //move the motor to home position for reset
  PAUSE = 1;
  analogWrite(GROOVE_TRACK_COARSE,256);
  Set_Mirr_Freq();
  Draw_GUI();
  
  setI2SFreq((MIRR_FREQ*2 ));

 

  analogWriteFrequency(GROOVE_TRACK_PIN_P, MIRR_FREQ*2);
  analogWriteFrequency(GROOVE_TRACK_PIN_N, MIRR_FREQ*2);
  analogWriteFrequency(GROOVE_TRACK_COARSE,MIRR_FREQ*4);

  analogWrite(GROOVE_TRACK_PIN_P, 0);
  analogWrite(GROOVE_TRACK_PIN_N, 0);
  
  analogWrite(GROOVE_TRACK_COARSE, 116);


    
  attachInterrupt(SIG_PIN_R, sig_rise_irq, RISING);
  attachInterrupt(SIG_PIN_F, sig_fall_irq, FALLING);
  ts.begin();


  //while(1){
  lsync_width = 0;
  lsync_counts = 0;
  rsync_counts = 0;

  uint32_t time_out = 0;
  uint32_t start_time = ARM_DWT_CYCCNT;
  while (lsync_counts < 100 && time_out < 10000000)
  {
    time_out ++;
    if (lsync_done == 1) {

      lsync_width += (lsync_fall_frame - lsync_rise_frame);
      lsync_counts++;
      lsync_done = 0;
      digitalWrite(28, 1);
    }
    else
    {
      digitalWriteFast(28, 0);
    }
  }
  if (time_out < 10000000)
  { MIRROR_TIME = (ARM_DWT_CYCCNT - start_time) / 200;
    MIRROR_FREQ = (float)600000000 / (float)(ARM_DWT_CYCCNT - start_time) * 100;
    Serial.print("Mirror Freq:");
    Serial.println(MIRROR_FREQ);

    //estimate the time of left and right signal.
    SIG_L_last = MIRROR_TIME / 2;
    SIG_R_last = MIRROR_TIME / 2;
    SIG_L_Sum =(MIRROR_TIME / 2) * Audio_Avg_Len ;
    SIG_R_Sum =(MIRROR_TIME / 2) * Audio_Avg_Len ;
    SIG_L_pre =   SIG_L_last;
    SIG_R_pre =   SIG_R_last;
     for (int i=0; i<Audio_Avg_Len; i++)
        {
           SIG_L_list[i]=MIRROR_TIME / 2;
           SIG_R_list[i]=MIRROR_TIME / 2;
        }
 
  }

 // delay(10000);

  time_out = 0;
  while ((rsync_counts < 100) && (time_out < 10000000)) {
    time_out ++;
    if (rsync_done == 1) {

      rsync_width += (rsync_fall_frame - rsync_rise_frame);

      rsync_counts++;
      rsync_done = 0;
      digitalWrite(28, 1);
    }
    else
    {
      digitalWriteFast(28, 0);
    }
  }


  lsync_width = lsync_width / 100;
  rsync_width = rsync_width / 100;

  Serial.print("Lsync width:");
  Serial.println(lsync_width);
  Serial.print("Rsync width:");
  Serial.println(rsync_width);
  //delay(100000);
  //}

//  lsync_start_frame = MIRROR_TIME;
  
 MIRROR_TIME = (uint32_t)((float)300000000 / (float)MIRR_FREQ);

   // t1->begin(ProcessAudioControl, ((1000000.0f ) / (float)(MIRR_FREQ) / 4.0));
  //  t1->begin(ProcessAudioControl, 4);
///check audio three times per scan, this makes sure that at least one check happen at DIR_LTR = 0 and DIR_LTR = 2.
}
int LTR_TIME = -100000;
int RTL_TIME = -100000;

#define MAX_SYNC_CORRECT 20000
//make sure it is bigger than MIRROR_TIME and does not cause double overflow in substraction
void ProcessAudioControl(){
  //drive the mirror with audio interrupt
//MIRR_CLK_STA = !MIRR_CLK_STA;
//digitalWriteFast(MIRR_CLK, MIRR_CLK_STA);
//remove glitches caused by overlapping interrupts.
 //t1->end();
 sei();
  if (((DIR_LTR>>1) == 0) && rsync_done) //process left to right scan
    { 
      lsync_start_local = lsync_start_frame;
     int test_sync = rsync_start_raw - lsync_start_local - LTR_TIME;
    //  Serial.println(test_sync);
     if((test_sync < 0) && (test_sync > (-MAX_SYNC_CORRECT)))
      {//here, rsync_start_frame is better(lower latency)
        LTR_TIME -= 1;
        rsync_start_frame = lsync_start_local + LTR_TIME; 
         //rsync_start_frame = rsync_start_raw;
         //LTR_TIME = rsync_start_raw - lsync_start_raw;
        
      }
      else if((test_sync < (MAX_SYNC_CORRECT)) && (test_sync > (-MAX_SYNC_CORRECT)))
      {//here, lsync_start_frame + LTR_TIME is better(lower latency)
        LTR_TIME+=1;//add something to avoid latching to this else
        rsync_start_frame = lsync_start_local + LTR_TIME; 
        // rsync_start_frame = rsync_start_raw;
        // LTR_TIME = rsync_start_raw - lsync_start_raw;
        
      }
      else //too much deviation, not safe to correct.
      { //Serial.println(rsync_start_raw - rsync_start_frame); //if this is not zero, increase timer poling rate
        LTR_TIME = rsync_start_raw - lsync_start_raw;
        rsync_start_frame = rsync_start_raw;
      //  lsync_start_frame = lsync_start_raw;
      //  lsync_start_local = lsync_start_raw;
      //   rsync_done = 0;
         New_Control_Data = 1;
         //we have an error, should not reach here except first run
     //   Serial.print(LTR_TIME);
     //   Serial.println(' ');
        //  Serial.println(test_sync);
      }
      
    }

   
   else if(((DIR_LTR>>1)  == 1) && (lsync_done))
   { rsync_start_local = rsync_start_frame;
     int test_sync = lsync_start_raw - rsync_start_local  - RTL_TIME;
       //  Serial.println(test_sync);
     if((test_sync < 0) && (test_sync > (-MAX_SYNC_CORRECT)))
     { 
    
       RTL_TIME -= 1 ;
       lsync_start_frame = rsync_start_local  + RTL_TIME;
      //lsync_start_frame = lsync_start_raw;
      //RTL_TIME =  lsync_start_raw - rsync_start_raw ;
     }
     else if((test_sync < (MAX_SYNC_CORRECT)) && (test_sync > (-MAX_SYNC_CORRECT)))
     {
        RTL_TIME+=1;
       lsync_start_frame = rsync_start_local  + RTL_TIME;
     // lsync_start_frame = lsync_start_raw;
     // RTL_TIME =  lsync_start_raw - rsync_start_raw ;
      //Serial.println(test_sync);
     }
     else
     {   //we have an error, should not reach here except first run
      //  Serial.println(RTL_TIME);
         RTL_TIME =  lsync_start_raw - rsync_start_raw ;
        // Serial.println(RTL_TIME);
         lsync_start_frame = lsync_start_raw;
      //   rsync_start_frame = rsync_start_raw;
      //   rsync_start_local = rsync_start_raw;
      //   lsync_done = 0;
         New_Control_Data = 1;
         //we have an error
     }
     
   }

//t1.trigger((MIRROR_TIME / 600)+2);
  

//no removal
/*
  if (((DIR_LTR>>1) == 0) && rsync_done) //process left to right scan
    { 
     rsync_start_frame = rsync_start_raw;
     lsync_start_local = lsync_start_raw;
    }
  else if(((DIR_LTR>>1)  == 1) && (lsync_done))
   {
    rsync_start_local = rsync_start_raw;
    lsync_start_frame = lsync_start_raw;
   }
  */
   if((PLAY_MODE < 3) && !PAUSE){
    if (((DIR_LTR>>1)  == 0) && rsync_done) //process left to right scan
    {   rsync_done = 0;
      //lsync_start_local = rsync_start_frame - MIRROR_TIME;
      //MIRROR_TIME = rsync_start_frame -  lsync_start_local;
     // MIRROR_TIME = (uint32_t)((float)300000000 / (float)MIRR_FREQ);
      //SIG_LTR from 0 to SIG_LTR_i-1, all sample are refered to cpu clock counter
      //SIG_LTR_R = 1 if rise
      //select point through compare to the moving average
      //use lsync_start and mirror time to transfer
      //use moving average to calculate and generate control signal.
      //calculate audio sample
      SIG_L_min = 0xff000000;
      SIG_R_min = 0xff000000;//dummy max
      NO_SIG_L = 1;
      NO_SIG_R = 1;
      SIG_L_index = 0;
      SIG_R_index = 0;
      //    SIG_R_last_LTR = MIRROR_TIME - SIG_R_last;
      if(DISC_TYPE != 1){
        
      for (tmp = 0; tmp < SIG_LTR_i; tmp++) {
        //      Serial.print(SIG_LTR[tmp]);
        //            Serial.print(' ');
        //      Serial.println(SIG_LTR_R[tmp]);

        if ((SIG_LTR_R[tmp]) == 0)
        {
          SIG_L_change = SIG_LTR[tmp] - lsync_start_local - SIG_L_pre;
          if (SIG_L_change < 0) {
            SIG_L_change = -SIG_L_change;
          }
          if (SIG_L_min > (uint32_t)SIG_L_change) {
            SIG_L_min = SIG_L_change;
            SIG_L_index = tmp;
            NO_SIG_L = 0;
      
          }
        }
       }
      }
      //method 1
      for (tmp = SIG_L_index ; tmp < SIG_LTR_i; tmp++) //to ensure that right sample is always on the right
      { 
    
        if ((SIG_LTR_R[tmp]) == 1)
        {
          
          if((rsync_start_frame - SIG_LTR[tmp]+ SIG_L_last) > (MIRROR_TIME - Groove_Width))
          {SIG_R_change =  rsync_start_frame - SIG_LTR[tmp] - SIG_R_pre;
           if (SIG_R_change < 0) {
            SIG_R_change = -SIG_R_change;
           }
          if (SIG_R_min > (uint32_t)SIG_R_change) {
            SIG_R_min = SIG_R_change;
            SIG_R_index = tmp;
            NO_SIG_R = 0;
            
          }
         }
        

       }
      }


   //method 2
 /*  if(SIG_L_index < (SIG_LTR_i-1))
   {      SIG_R_index = SIG_L_index + 1;
          SIG_R_change =  rsync_start_frame - SIG_LTR[SIG_R_index] - SIG_R_pre;
          if((rsync_start_frame - SIG_LTR[SIG_R_index]+ SIG_L_last) > (MIRROR_TIME - Groove_Width))
          {
          if (SIG_R_change < 0) {
            SIG_R_change = -SIG_R_change;
          }
          if (SIG_R_min > (uint32_t)SIG_R_change) {
            SIG_R_min = SIG_R_change;
            NO_SIG_R = 0;
          }
       }

   }*/

      SIG_L_change = SIG_LTR[SIG_L_index] - lsync_start_local - SIG_L_last;
        if (SIG_L_change < 0) {
            SIG_L_change = -SIG_L_change;
          }

      if(!NO_SIG_L)
      {
        if(((SIG_R_index - SIG_L_index) != 1) && (!NO_SIG_R) && (DISC_TYPE == 1))
        {
          if(skip_count > (MAX_SKIP))
          {
            SIG_R_index = SIG_L_index + 1;
            Serial.println('s');
            Max_Jump = MIRROR_TIME;
          }
          else
          {
           skip_count += 1;
         //  Serial.println('s');
          }
        }
        else if(!NO_SIG_R)
        {  //Serial.println(skip_count);
          if(skip_count > 0)
            {skip_count -- ;}
        }
      }
       
      
      if(NO_SIG_L && (NO_SIG_L_count < MIRR_FREQ)){
        NO_SIG_L_count++;
      }   
      else if ((!NO_SIG_L)  && (SIG_L_min < (Max_Jump)) && (SIG_L_change < (Max_Jump))) {
        //send the last sample to audio
        //record last sample to control system
        NO_SIG_L_count = 0;
        SIG_L_last = SIG_LTR[SIG_L_index] - lsync_start_local;
        if(SIG_L_last > MIRROR_TIME)
        {
          SIG_L_last = 0;
        }

        L_Audio_Data = (int16_t)(((float)SIG_L_last / (float)MIRROR_TIME - 0.5) * 65535.0);
     
      }
      else
      {
        NO_SIG_L = 1;
        if(NO_SIG_L_count < MIRR_FREQ)
        {NO_SIG_L_count++;}
      }

 /*     else if(!NO_SIG_R && (SIG_R_change < Max_Jump))
      { SIG_L_last =  SIG_LTR[SIG_R_index]- lsync_start_local - Groove_Width;
        if(SIG_L_last > MIRROR_TIME)
        {
          SIG_L_last = 0;
        }
        L_Audio_Data = (int16_t)(((float)SIG_L_last / (float)MIRROR_TIME - 0.5) * 65535.0);
      }
     */
      SIG_R_change = SIG_R_last - (rsync_start_frame - SIG_LTR[SIG_R_index]) ;
         if (SIG_R_change < 0) {
            SIG_R_change = -SIG_R_change;
          } 
      if(NO_SIG_R && (NO_SIG_R_count < MIRR_FREQ)){
        NO_SIG_R_count++;
      }     
      else if ((!NO_SIG_R) && (SIG_R_min < Max_Jump) && ((SIG_R_change < (Max_Jump)))) {
        NO_SIG_R_count = 0;
        SIG_R_last = rsync_start_frame - SIG_LTR[SIG_R_index];
        if(SIG_R_last > MIRROR_TIME)
        {
          SIG_R_last = 0;
        }
        R_Audio_Data = (int16_t)(((float)SIG_R_last / (float)MIRROR_TIME - 0.5) * 65535.0);
     
      }
      else
      {
        NO_SIG_R = 1;
        if(NO_SIG_R_count < MIRR_FREQ)
         {NO_SIG_R_count++;}
      }

         if(DISC_TYPE == 1)
         {
           L_Audio_Data = -R_Audio_Data ;
           SIG_L_last = MIRROR_TIME - SIG_R_last;
           NO_SIG_L_count = NO_SIG_R_count;
           NO_SIG_L = NO_SIG_R;
         }
         else if(DISC_TYPE == 2)
        {  
          R_Audio_Data = -L_Audio_Data ;
          SIG_R_last = MIRROR_TIME - SIG_L_last;
          NO_SIG_R_count = NO_SIG_L_count;
          NO_SIG_R = NO_SIG_L;
        }
      if(CORRECT_COUNT<(10 * MIRR_FREQ))
      {CORRECT_COUNT += (!NO_SIG_L && !NO_SIG_R);}
      else if(CORRECT_COUNT>0)
      {CORRECT_COUNT -= (NO_SIG_L || NO_SIG_R);}
       //digitalWriteFast(13,(NO_SIG_R || NO_SIG_L));
      if(NO_SIG_COUNT < (100 * MIRR_FREQ))
      {NO_SIG_COUNT += (NO_SIG_R || NO_SIG_L);}
      if((!NO_SIG_L && !NO_SIG_R) == 1)
      {NO_SIG_COUNT = 0;}
   /*   else if(!NO_SIG_L && (SIG_L_change < Max_Jump))
      {  SIG_R_last = rsync_start_frame - SIG_LTR[SIG_L_index] - Groove_Width;
         if(SIG_R_last > MIRROR_TIME)
        {
          SIG_R_last = 0;
        }
         R_Audio_Data = (int16_t)(((float)SIG_R_last / (float)MIRROR_TIME - 0.5) * 65535.0);
      }
*/
      //SIG_LTR_i = 0;
      G_Tracking_Error = (int)L_Audio_Data - (int)R_Audio_Data + T_Bias;
      Track_Array[Tracking_RC] = G_Tracking_Error;
      Tracking_RC++;
      if (Tracking_RC >= AVG_len)
      {
        Tracking_RC = 0;
      }
      G_Tracking_Diff = G_Tracking_Error - Track_Array[Tracking_RC];
      Track_Sum += G_Tracking_Diff;
      New_Control_Data = 1;
    }
    else if (((DIR_LTR>>1)==1) && (lsync_done == 1)) //process right to left scan
    { lsync_done = 0;

      //lsync_start_frame = rsync_start_local + MIRROR_TIME;
    //  MIRROR_TIME = lsync_start_frame -  rsync_start_local;
   //   MIRROR_TIME = (uint32_t)((float)300000000 / (float)MIRR_FREQ);
      SIG_L_min = 0xff000000;
      SIG_R_min = 0xff000000;//dummy max
      NO_SIG_L = 1;
      NO_SIG_R = 1;
      SIG_R_index = 0;
      SIG_L_index = 0;
      //     SIG_L_last_RTL = MIRROR_TIME - SIG_L_last;

       if(DISC_TYPE != 2){
        for (tmp = 0; tmp < SIG_RTL_i; tmp++) {
       
        if ((SIG_RTL_R[tmp]) == 0)
        {
          
          if((SIG_RTL[tmp] - rsync_start_local + SIG_L_last)> (MIRROR_TIME - Groove_Width))
          {SIG_R_change = SIG_RTL[tmp] - rsync_start_local - SIG_R_pre;
           if (SIG_R_change < 0) {
            SIG_R_change = -SIG_R_change;
           }
          if (SIG_R_min > (uint32_t)SIG_R_change) {
            SIG_R_min = SIG_R_change;
            SIG_R_index = tmp;
            NO_SIG_R = 0;
          }
       
         }
        }
       }
      
      }
      for (tmp = SIG_R_index; tmp < SIG_RTL_i; tmp++) 
      {  
      
        if ((SIG_RTL_R[tmp]) == 1)
        {
          SIG_L_change =  lsync_start_frame - SIG_RTL[tmp] - SIG_L_pre;
        
          if (SIG_L_change < 0) {
            SIG_L_change = -SIG_L_change;
          }
          if (SIG_L_min > (uint32_t)SIG_L_change) {
            SIG_L_min = SIG_L_change;
            SIG_L_index = tmp;
            NO_SIG_L = 0;
          }
          
         }
      }

/* if(DISC_TYPE == 1)
   {
    SIG_L_index = SIG_R_index;
    NO_SIG_L = NO_SIG_R;
    SIG_L_min = SIG_R_min;
   }
   */
      SIG_L_change =  lsync_start_frame - SIG_RTL[SIG_L_index] - SIG_L_last;
        if (SIG_L_change < 0) {
            SIG_L_change = -SIG_L_change;
          }

      if(!NO_SIG_L)
      {
        if(((SIG_L_index - SIG_R_index) != 1) && (!NO_SIG_R) && (DISC_TYPE == 0))
        {
          if(skip_count > (MAX_SKIP))
          {
            SIG_R_index = SIG_L_index - 1;
            Serial.println('s');
            Max_Jump = MIRROR_TIME;
          }
          else 
          {
            skip_count += 1;
           //  Serial.println('s');
          }
        }
        else if(!NO_SIG_R)
        {if(skip_count > 0)
          {skip_count -- ;}
        }
      }

      if(NO_SIG_L && (NO_SIG_L_count < MIRR_FREQ)){
        NO_SIG_L_count++;
      } 
      else if ((!NO_SIG_L)  && (SIG_L_min< Max_Jump) && (SIG_L_change < (Max_Jump))) {
        //send the last sample to audio
        //record last sample to control system
     
        NO_SIG_L_count = 0;
        SIG_L_last = lsync_start_frame - SIG_RTL[SIG_L_index];
        if(SIG_L_last > MIRROR_TIME)
        {
          SIG_L_last = 0;
        }
        L_Audio_Data = (int16_t)(((float)SIG_L_last / (float)MIRROR_TIME - 0.5) * 65535.0);
   
      }
      else
      {
       NO_SIG_L = 1;
       if(NO_SIG_L_count < MIRR_FREQ)
       {NO_SIG_L_count++;}
      }
  /*    else if(!NO_SIG_R && (SIG_R_change < Max_Jump))
      { SIG_L_last =  lsync_start_frame - SIG_RTL[SIG_R_index] - Groove_Width;
         if(SIG_L_last > MIRROR_TIME)
        {
          SIG_L_last = 0;
        }
        L_Audio_Data = (int16_t)(((float)SIG_L_last / (float)MIRROR_TIME - 0.5) * 65535.0);
      }
    */

    
         SIG_R_change =  SIG_R_last - (SIG_RTL[SIG_R_index] - rsync_start_local);
          if (SIG_R_change < 0) {
            SIG_R_change = -SIG_R_change;
          } 
      if(NO_SIG_R && (NO_SIG_R_count < MIRR_FREQ)){
        NO_SIG_R_count++;
      }    
      else if ((!NO_SIG_R) && (SIG_R_min < Max_Jump) && (SIG_R_change < (Max_Jump)) ) {
        NO_SIG_R_count = 0;
        SIG_R_last = SIG_RTL[SIG_R_index] - rsync_start_local;
        if(SIG_R_last > MIRROR_TIME)
        {
          SIG_R_last = 0;
        }
        R_Audio_Data = (int16_t)(((float)SIG_R_last / (float)MIRROR_TIME - 0.5) * 65535.0);
      
      }
      else{
        NO_SIG_R = 1;
        if(NO_SIG_R_count < MIRR_FREQ)
        {NO_SIG_R_count++;}
      }

       if(DISC_TYPE == 1)
         {
           L_Audio_Data = -R_Audio_Data ;
           SIG_L_last = MIRROR_TIME - SIG_R_last;
           NO_SIG_L_count = NO_SIG_R_count;
           NO_SIG_L = NO_SIG_R;
         }
        else if(DISC_TYPE == 2)
        {  
          R_Audio_Data = -L_Audio_Data ;
          SIG_R_last = MIRROR_TIME - SIG_L_last;
          NO_SIG_R_count = NO_SIG_L_count;
          NO_SIG_R = NO_SIG_L;
        }
     
      
      if(CORRECT_COUNT<(10 * MIRR_FREQ))
      {CORRECT_COUNT += (!NO_SIG_L && !NO_SIG_R);}
      else if(CORRECT_COUNT>0)
      {CORRECT_COUNT -= (NO_SIG_L ||  NO_SIG_R);}
      //digitalWriteFast(13,(NO_SIG_R || NO_SIG_L));

      if(NO_SIG_COUNT < (100 * MIRR_FREQ))
      {NO_SIG_COUNT += (NO_SIG_R || NO_SIG_L);}
      if((!NO_SIG_L && !NO_SIG_R) == 1)
      {NO_SIG_COUNT = 0;}
   /*   else if(!NO_SIG_L && (SIG_L_change < Max_Jump))
      {  SIG_R_last =  SIG_RTL[SIG_L_index] - rsync_start_local - Groove_Width;
        if(SIG_R_last > MIRROR_TIME)
        {
          SIG_R_last = 0;
        }
         R_Audio_Data = (int16_t)(((float)SIG_R_last / (float)MIRROR_TIME - 0.5) * 65535.0);
      }
    */  
     // SIG_RTL_i = 0;
      G_Tracking_Error = (int)L_Audio_Data - (int)R_Audio_Data + T_Bias;
      Track_Array[Tracking_RC] = G_Tracking_Error;
      Tracking_RC++;
      if (Tracking_RC >= AVG_len)
      {
        Tracking_RC = 0;
      }
      G_Tracking_Diff = G_Tracking_Error - Track_Array[Tracking_RC];
      Track_Sum += G_Tracking_Diff;
      New_Control_Data = 1;
    }




    
    if (New_Control_Data == 1)
    {  
      if(CTRL_ON){    
      if ((G_Tracking_Inti < int(0x10000000)) && (G_Tracking_Inti > int(0xe0000000))) //no need to integrate more then 256 max values
      {
        G_Tracking_Inti = G_Tracking_Inti + Track_Sum/AVG_len;
      }
      else if ((G_Tracking_Inti > int(0x10000000)) && (Track_Sum < 0))
      {
        G_Tracking_Inti = G_Tracking_Inti + Track_Sum/AVG_len;
      }
      else if ((G_Tracking_Inti < int(0xe0000000)) && (Track_Sum > 0))
      {
        G_Tracking_Inti = G_Tracking_Inti + Track_Sum/AVG_len;
      }
      else
      {
       RESET_CTRL();
       Serial.println("Control overflow, reset control");
      }
      G_Tracking_Force =  (Kd * G_Tracking_Diff +  (Ki *G_Tracking_Inti >> 2) +  (Kp *Track_Sum>>2)) >> K_shift;
     //  G_Tracking_Force =   Kp * (Track_Sum) >> K_shift;
   


      if (G_Tracking_Force >= 0) {
        //move right

        analogWrite(GROOVE_TRACK_PIN_P, (G_Tracking_Force+256)>>1);
        //analogWrite(GROOVE_TRACK_PIN_P, (G_Tracking_Force));
        //analogWrite(GROOVE_TRACK_PIN_N, 0);
      }
      else
      {
        analogWrite(GROOVE_TRACK_PIN_P, (G_Tracking_Force+256)>>1);
       // analogWrite(GROOVE_TRACK_PIN_P, 0);
       // analogWrite(GROOVE_TRACK_PIN_N, (-G_Tracking_Force));
      }
      //if voice coil hit the end of strock, move motor
      G_Tracking_Error_l = G_Tracking_Error;

   /*   if(NO_SIG_COUNT > 1000)
      {
        AUDIO_ON = 0;
      }
      else if(CORRECT_COUNT > 1000)
      {
        AUDIO_ON = 1;
      }
        */
      if((CORRECT_COUNT < 5000) || (NO_SIG_COUNT > 5000) )
      {
        Coarse_Force = 0;
        //Serial.print('n');
      }
      else
      {
       // Coarse_Force = G_Tracking_Force;
       Coarse_Force = ((Kp *Track_Sum*4)>>(K_shift)) +  ((Ki *G_Tracking_Inti) >> (3+K_shift));
      //  Coarse_Force =  (Kd * G_Tracking_Diff + Ki * (G_Tracking_Inti >> 2) + Kp * (Track_Sum>>2)) >> K_shift;
   
        //too much = motor noise
        //too slow = more tracking err
       // Coarse_Force = G_Tracking_Inti>>19;
      }
    //  Coarse_Force = G_Tracking_Force>>2;
     //you may need bias = 15 opposite for coarse force, this is more stable than no bias.
      if (Coarse_Force < (116))
      {
        //Serial.println(Coarse_Force);
        analogWrite(GROOVE_TRACK_COARSE, 116 - Coarse_Force); //smaller is left bigger is right.
      }
      else 
      {
        analogWrite(GROOVE_TRACK_COARSE, 0);
      }

    }

      
     
     if((NO_SIG_L_count == 0) && (NO_SIG_L_count_l!=0))
     {//Serial.println(NO_SIG_L_count_l);
      if(NO_SIG_L_count_l < 7)
      {
        Denoise_Len = NO_SIG_L_count_l;
      }
      else
      {
        Denoise_Len = 7;
      }
      Denoise_Slop = (L_Audio_Data - (Denoise_L_Audio[(Denoise_RC - Denoise_Len - 1) & Denoise_Mask]))/(Denoise_Len+1);
      for(tmp = 1; tmp <= Denoise_Len; tmp++)
       {
        Denoise_L_Audio[(Denoise_RC - tmp) & Denoise_Mask] = L_Audio_Data - (Denoise_Slop * (tmp));
       }
     }

     if((NO_SIG_R_count == 0) && (NO_SIG_R_count_l!=0))
     {//Serial.println(NO_SIG_L_count_l);
      if(NO_SIG_R_count_l < 7)
      {
        Denoise_Len = NO_SIG_R_count_l;
      }
      else
      {
        Denoise_Len = 7;
      }
      Denoise_Slop = (R_Audio_Data - (Denoise_R_Audio[(Denoise_RC - Denoise_Len - 1) & Denoise_Mask]))/(Denoise_Len+1);
      for(tmp = 1; tmp <= Denoise_Len; tmp++)
       {
        Denoise_R_Audio[(Denoise_RC - tmp) & Denoise_Mask] = R_Audio_Data - (Denoise_Slop * (tmp));
       }
     }

      NO_SIG_L_count_l = NO_SIG_L_count;
      NO_SIG_R_count_l = NO_SIG_R_count;

      L_Audio_Denoise = Denoise_L_Audio[(Denoise_RC) & Denoise_Mask];
      R_Audio_Denoise = Denoise_R_Audio[(Denoise_RC) & Denoise_Mask];
      
      L_Audio_Data_d = L_Audio_Denoise - L_Audio_Data_l;
      R_Audio_Data_d = R_Audio_Denoise - R_Audio_Data_l;
  //   if(play_audio){
     if(AUDIO_ON){
       if(audio_enhancer)
       {//Left_audio.play((L_Audio_Denoise + L_Audio_Denoise + L_Audio_Data_dl)>>2);
        //Right_audio.play((-(R_Audio_Denoise + R_Audio_Denoise + R_Audio_Data_dl))>>2);
        L_OUT = (L_Audio_Denoise + L_Audio_Denoise + L_Audio_Data_dl)>>2;
        R_OUT = (-(R_Audio_Denoise + R_Audio_Denoise + R_Audio_Data_dl))>>2;
       }
       else
       {//Left_audio.play(L_Audio_Data);
        //Right_audio.play(-R_Audio_Data);
        L_OUT = L_Audio_Data;
        R_OUT = -R_Audio_Data;
       }
      }
      else
      {
        L_OUT =0;
        R_OUT =0;
      }
      
   //    play_audio=0;
    // }
      L_Audio_Data_l = L_Audio_Denoise;
      R_Audio_Data_l = R_Audio_Denoise;
      L_Audio_Data_dl = L_Audio_Data_d;
      R_Audio_Data_dl = R_Audio_Data_d;
     
      Denoise_L_Audio[Denoise_RC & Denoise_Mask] = L_Audio_Data;
      Denoise_R_Audio[Denoise_RC & Denoise_Mask] = R_Audio_Data;
      Denoise_RC ++;

  
     
       
       if(NO_SIG_COUNT >= (MIRR_FREQ * 2))
         {
            RESET_CTRL();
            Serial.println("Bad Signal, reset control");
           // Serial.println(GPIO9_ISR);
         }
      
/*
         UpSample_Buff_R[UpSample_Buff_RC] =  -R_Audio_Data;
         UpSample_Buff_L[UpSample_Buff_RC] = L_Audio_Data;
         UpSample_Buff_RC += 1; */
      /*if((uint32_t)(SIG_R_last+SIG_L_last) < (uint32_t)(MIRROR_TIME / 100))
       {
        SIG_L_last = MIRROR_TIME / 2;
        SIG_R_last = MIRROR_TIME / 2;
       }*/
      New_Control_Data = 0;
 
    
  if(CORRECT_COUNT > (Audio_Avg_Len>>5))
    {
    //predict next sample using Moving Average
     SIG_L_list[Audio_RC]=SIG_L_last;
     SIG_R_list[Audio_RC]=SIG_R_last;
     Audio_RC ++;
     if(Audio_RC >= Audio_Avg_Len)
     {
      Audio_RC = 0;
     }
   
    SIG_L_Sum += SIG_L_last-SIG_L_list[Audio_RC];
    SIG_R_Sum += SIG_R_last-SIG_R_list[Audio_RC];

    //output the prediction back
    
          SIG_L_pre=SIG_L_Sum/Audio_Avg_Len;
          SIG_R_pre=SIG_R_Sum/Audio_Avg_Len;
          if(DISC_TYPE != 0)
          {Groove_Width = MIRROR_TIME;
           Max_Jump = MIRROR_TIME/6 ;
          }
          else if(DEGLITCH)
          {Groove_Width = MIRROR_TIME - SIG_L_pre - SIG_R_pre + Max_Dev;
           if(Groove_Width>GROOVE_WIDTH_MAX)
           {Groove_Width=GROOVE_WIDTH_MAX;} 
           Max_Dev =  Groove_Width/2;
           Max_Jump = Max_Dev ;
          }
          else
          { Groove_Width =  MIRROR_TIME;
            Max_Jump =  MIRROR_TIME/3;
          }


        
       
     }



        if (NULL == UpSample_Buff_L)
        {nulls++;
         UpSample_Buff_L = Left_audio.getBuffer();
         UpSample_Buff_RC_L = 0;
        }
        
        else{
         UpSample_Buff_L[UpSample_Buff_RC_L] = L_OUT;
         UpSample_Buff_RC_L ++;
        }
       
        if(NULL == UpSample_Buff_R)
         { nulls++;
           UpSample_Buff_R = Right_audio.getBuffer();
           UpSample_Buff_RC_R = 0;
         }
        else{
          UpSample_Buff_R[UpSample_Buff_RC_R] = R_OUT;
          UpSample_Buff_RC_R += 1;
        }
   
     
     if (UpSample_Buff_RC_L == AUDIO_BLOCK_SAMPLES)
      { 
        
        UpSample_Buff_RC_L = 0;
        Left_audio.playBuffer();
        UpSample_Buff_L = Left_audio.getBuffer();
      } 

      if (UpSample_Buff_RC_R == AUDIO_BLOCK_SAMPLES)
      { 
        
        UpSample_Buff_RC_R = 0;
        Right_audio.playBuffer();
        UpSample_Buff_R = Right_audio.getBuffer();
      } 

    }
 
   }
    else if (PLAY_MODE == 3){
      //next song
       if(!start_reset)
      {start_reset = 1;
        RESET_CTRL();
        reset_start = micros();
       trough_count = 0;
       analogWrite(GROOVE_TRACK_COARSE, 0);
        IN_SONG = 0;
        in_song_count = 0;
      }
      if(((DIR_LTR>>1)  == 0) && (rsync_done == 1))
      { if(!IN_SONG)
        {if(SIG_LTR_i > 1)
          {
            if(in_song_count>(MIRR_FREQ/4))
             {IN_SONG = 1;
              Serial.println("IN SONG");
             }
             else
             {
              in_song_count++;
             }
          }
         else if(in_song_count>0)
          {in_song_count--;}
        }
        else{
        if(SIG_LTR_i <= 1)
         {if(digitalRead(SIG_PIN_R) == 1)
           {trough_count ++;}
          else 
           {trough_count = 0;}

           if((trough_count >= (MIRR_FREQ/1000)) && ((micros()-reset_start)>10000))
           {
            PLAY_MODE = 0;
            start_reset = 0;
             analogWrite(GROOVE_TRACK_COARSE, 116);
            Serial.println("Get Next Song");
           }
          }
          else
          {
           trough_count = 0;
          }
         }
         rsync_done = 0;
      }
      else 
      {lsync_done = 0;
       NO_SIG_L = 1;
       NO_SIG_R = 1;
      }

    }
    else if (PLAY_MODE == 4){
      //prev song
      if(!start_reset)
      {start_reset = 1;
        RESET_CTRL();
        reset_start = micros();
       trough_count = 0;
       analogWrite(GROOVE_TRACK_COARSE, 256);
       IN_SONG = 0;
       in_song_count = 0;
      }
      if(((DIR_LTR>>1)  == 0) && (rsync_done == 1))
      { 
        if(!IN_SONG)
        {if(SIG_LTR_i > 1)
          {
            if(in_song_count>(MIRR_FREQ/4))
             {IN_SONG = 1;
              Serial.println("IN SONG");
             }
             else{
             in_song_count++;
             }
          }
         else if(in_song_count>0)
          {in_song_count--;}
        }
        else{
        if(SIG_LTR_i <= 1)
         {if(digitalRead(SIG_PIN_R) == 1)
           {trough_count ++;
            
           }
          else
           {
            trough_count = 0;
           }

           if((trough_count >= (MIRR_FREQ/1000)) && ((micros()-reset_start)>10000))
           {
            PLAY_MODE = 0;
            start_reset = 0;
            analogWrite(GROOVE_TRACK_COARSE, 116);
            Serial.println("Get Prev Song");
           }
         }
         else
         {
         // Serial.println(trough_count);
          trough_count = 0;
          
         }
        }
         rsync_done = 0;
      }
      else 
      {lsync_done = 0;
       NO_SIG_L = 1;
       NO_SIG_R = 1;
      }
   
      
    }
    else if (PLAY_MODE == 5){
      if(!start_reset)
      {start_reset = 1;
       OUTEDGE = 0;
        RESET_CTRL();
        reset_start = micros();
       trough_count = 0;
       analogWrite(GROOVE_TRACK_COARSE, 256);
      }

   
      if((DIR_LTR>>1)  == 0 &&(rsync_done == 1))
      { 
        
      if(OUTEDGE == 1)
      {trough_count ++ ;
        if(trough_count > (MIRR_FREQ/20))
         { //PLAY_MODE = 0;
           start_reset = 0;
           OUTEDGE = 0;
           Serial.println("Finish Reset");
         }
      }
      else if((SIG_LTR_i == 0))
         {if(digitalRead(SIG_PIN_R) == 0)
           {trough_count ++;}
          else
           {trough_count = 0;}

           if((trough_count >= (MIRR_FREQ/40)) && ((micros()-reset_start)>10000))
           {
            OUTEDGE = 1;
            analogWrite(GROOVE_TRACK_COARSE, 0);
            trough_count = 0;
           }
         rsync_done = 0;
         }
         else
         {  
          trough_count = 0;
         }
         rsync_done = 0;
      }
      else 
      {lsync_done = 0;
       NO_SIG_L = 1;
       NO_SIG_R = 1;
      }
   
 
      //reset
    }
     else if (PLAY_MODE == 6){
      //land cartbridge
       if(!start_reset)
       {start_reset = 1;
        RESET_CTRL();
        reset_start = micros();
       trough_count = 0;
       analogWrite(GROOVE_TRACK_COARSE, 0);
        IN_SONG = 0;
        in_song_count = 0;
      }
      if(((DIR_LTR>>1) == 0) && (rsync_done == 1))
      { if(!IN_SONG)
        {if(SIG_LTR_i > 1)
          {
            if(in_song_count>(MIRR_FREQ))
             {IN_SONG = 1;
              Serial.println("IN SONG");
              analogWrite(GROOVE_TRACK_COARSE, 256);
             }
             else
             {
              in_song_count++;
             }
          }
         else if(in_song_count>0)
          {in_song_count--;}
        }
        else{
        if(SIG_LTR_i == 0)
         {if(digitalRead(SIG_PIN_R) == 1)
           {trough_count ++;}
          else 
           {trough_count = 0;}

           if((trough_count >= (MIRR_FREQ/200)) && ((micros()-reset_start)>10000))
           {
            PLAY_MODE = 0;
            start_reset = 0;
             analogWrite(GROOVE_TRACK_COARSE, 116);
            Serial.println("Landed");
           }
          }
          else
          {
           trough_count = 0;
          }
         }
         rsync_done = 0;
      }
      else 
      {lsync_done = 0;
       NO_SIG_L = 1;
       NO_SIG_R = 1;
      }

    }
    else
    {
      delayMicroseconds(1);
      if((DIR_LTR >> 1) == 0)
      {
       rsync_done = 0;
       NO_SIG_L = 1;
       NO_SIG_R = 1;
      }
      else 
      {lsync_done = 0;
       NO_SIG_L = 1;
       NO_SIG_R = 1;
      }
    }
    STATE_CHECK++;
}

boolean wastouched = true;
uint8_t RAW_COUNT = 255;
int last_kp = Kp;
uint32_t Delay_Time = 0;
uint32_t lsync_local = 0;
uint32_t rsync_local = 0;


bool NO_L_D = 1;
bool NO_R_D = 1;
uint8_t SIG_L_D = 0;
uint8_t SIG_R_D = 0;
uint32_t TEXT_COUNT = 0;
uint32_t dead_count = 0;
void loop() {
  
  while (1)
  {  Delay_Time = MIRROR_TIME / 600;

   /*  if(STATE_CHECK & 0x00000100) 
     {
      Lines_i = 0;
     }*/


     
     if(((DIR_LTR) == 0)&& (!rsync_done)/* && (SIG_LTR_i>=Lines_i)*/)
     {if(DRAWN){
       DRAWN = 0;
       lsync_local = lsync_start_frame;
       Lines_i = SIG_LTR_i;
       NO_L_D = NO_SIG_L;
       NO_R_D = NO_SIG_R;
       SIG_L_D = SIG_L_index;
       SIG_R_D = SIG_R_index;
       
        for (int i = 0; i< Lines_i; i++) {
         Lines_Val[i] = (uint16_t)((float)(SIG_LTR[i] - lsync_local)/(float)MIRROR_TIME*192.0);
       }
      // delayMicroseconds(Delay_Time);
      }
     
     
     } 
     else if(((DIR_LTR) == 2) && (!lsync_done)/* && (SIG_RTL_i >= Lines_i)*/)
     {if(DRAWN){
       DRAWN = 0;
       NO_L_D = NO_SIG_L;
       NO_R_D = NO_SIG_R;
       SIG_L_D = SIG_L_index;
       SIG_R_D = SIG_R_index;
       Lines_i = SIG_RTL_i;
       rsync_local = rsync_start_frame;
       for (int i = 0; i<Lines_i; i++) {
           Lines_Val[i] = (uint16_t)((float)(MIRROR_TIME - (SIG_RTL[i] - rsync_local))/(float)MIRROR_TIME*192.0);
        }
       // delayMicroseconds(Delay_Time);
       }
       
     }

     if(TEXT_COUNT >8)
     {TEXT_COUNT = 0;
      Write_Groove_Width();
     }

 //Serial.println(STATE_CHECK);
  // DRAWN = 1;
    if((STATE_CHECK > 1024) && !DRAWN)
    { tft.SPI_Init();
      for (int i = 0; i< Lines_i_l; i++) {
         tft.drawFastVLine(64 + Lines_Val_l[i], 128, 32, ILI9341_BLACK);
       }
      for (int i = 0; i< Lines_i; i++) {
        if(Lines_Val[i] < 192){
        if((!NO_L_D) && (i == SIG_L_D) && (DISC_TYPE != 1))
        {
          tft.drawFastVLine(64 + Lines_Val[i], 128, 32, ILI9341_ORANGE);
        }
        else if((!NO_R_D) && (i == SIG_R_D) && (DISC_TYPE != 2))
        {
          tft.drawFastVLine(64 + Lines_Val[i], 128, 32, ILI9341_YELLOW);
        }
         else{
         tft.drawFastVLine(64 + Lines_Val[i], 128, 32, ILI9341_PINK);
         }
         Lines_Val_l[i] = Lines_Val[i];
        }
         
       }
       Lines_i_l=  Lines_i;
       DRAWN = 1;
       Lines_i = 0;
    }

  
    if(STATE_CHECK > 1024)
    {STATE_CHECK = 0;
     dead_count = 0;
     TEXT_COUNT ++ ;
    
    
      ts.begin();
      boolean istouched = ts.touched();
  if (istouched) {
    TS_Point p_raw = ts.getPoint();
    TS_Point p = TS_Point(4095 - p_raw.x, 4095 - p_raw.y, p_raw.z); // flip both axes for 180°

    if (!wastouched) {
      if((p.x/950) > 2)
       {if(p.y/750 == (PLAY_PAUSE_X/64))
        {AUDIO_ON = !AUDIO_ON;
         CTRL_ON = AUDIO_ON;
         PLAY_MODE = 0;
          start_reset = 0;
          analogWrite(GROOVE_TRACK_COARSE, 116);
         
         //Serial.println(p.x);
         if(AUDIO_ON)
         {PAUSE = 0;
          Draw_Pause(ILI9341_YELLOW);
         }
         else
         {
          Draw_Play(ILI9341_GREEN);
          PAUSE = 1;
           analogWrite(GROOVE_TRACK_COARSE, 116);
         }
        }
        else if(p.y/750 == (FORW_X/64))
        {
          Draw_Forw(ILI9341_WHITE);
          Draw_Pause(ILI9341_YELLOW);
        }
        else if(p.y/750 == (BACK_X/64))
        {
          Draw_Back(ILI9341_WHITE);
          Draw_Pause(ILI9341_YELLOW);
        }
        else if(p.y/750 == (NEXT_X/64))
        {
          Draw_Next(ILI9341_WHITE);
          PLAY_MODE = 3;
          start_reset = 0;
          CTRL_ON = 1;
        }
        else if(p.y/750 == (PREV_X/64))
        {
          Draw_Prev(ILI9341_WHITE);
          PLAY_MODE = 4;
          start_reset = 0;
          CTRL_ON = 1;
        }
        
       }
       else if((p.x/950) == 2)
       {if((p.y/750) == 2) //change groove type
         {DISC_TYPE ++;
          if(DISC_TYPE > 2)
          {
            DISC_TYPE = 0;
          }
         }       
       }

       if((p.y/750) == 0)
       {
          if((p.x/950) == (LAND_Y/60)){
          PLAY_MODE = 6;
          start_reset = 0;
          Draw_Land(ILI9341_WHITE);
          
         }
         else if((p.x/950) == (EDGE_Y/60)){
          PLAY_MODE = 5;
          start_reset = 0;
          Draw_Edge(ILI9341_WHITE);
         }
         else if((p.x/950) == (RST_Y/60)){
            PAUSE = 1;
            PLAY_MODE = 0;
            start_reset = 0;
            Draw_Play(ILI9341_GREEN);
            Draw_Reset(ILI9341_WHITE);
            analogWrite(GROOVE_TRACK_COARSE, 256);
         }
       
      }

      if((p.x/950)== 0){
        if((p.y/750) == (EQ_X/64))
        {
          EQ_MODE++;
          if(EQ_MODE > 2)
          {
            EQ_MODE = 0;
            Draw_Eq('V');
            Draw_Vol(global_volume);
          }
          else if(EQ_MODE == 2)
          {
            Draw_Eq('T');
            Draw_Vol((global_treble+1.0)/2.0);
          }
          else if(EQ_MODE == 1)
          {
            Draw_Eq('B');
            Draw_Vol((global_bass+1.0)/2.0);
          }
        }
      }
          

   
      
   /*   tft.SPI_Init();
      tft.fillScreen(ILI9341_BLACK);
      tft.setTextColor(ILI9341_YELLOW);
      tft.setTextSize(6);
      //tft.setFont(Arial_60);
      tft.setCursor(60, 80);
      tft.print("Touch");
      */
       //Serial.println("Touch");
    }
    
      if((p.x/950) > 2)
       {if(p.y/750 == (BACK_X/64))
        {/*AUDIO_ON = 1;
         CTRL_ON = 0;
         PLAY_MODE = 0;
         PAUSE = 0;
         BACK_PRESSED = 1;
         analogWrite(GROOVE_TRACK_COARSE, 256);*/

         AUDIO_ON = 1;
         CTRL_ON = 1;
         PLAY_MODE = 0;
         BACK_PRESSED = 1;
       //  last_kp = Kp;
       //  Kp = 0;
         if(RAW_COUNT > 10)
         {
          RAW_COUNT = 0;
          PAUSE = 1;
          //RESET_CTRL();
          analogWrite(GROOVE_TRACK_COARSE, 256);
          analogWrite(GROOVE_TRACK_PIN_P, 0);
          analogWrite(GROOVE_TRACK_PIN_N, 0);
          Track_Sum = 0;
          NO_SIG_COUNT = 0;
          G_Tracking_Inti = 0;
          Groove_Width = 6000;
          SIG_L_last = (MIRROR_TIME / 2);
          SIG_R_last = (MIRROR_TIME / 2);
          SIG_L_Sum =(SIG_L_last) * Audio_Avg_Len ;
          SIG_R_Sum =(SIG_R_last) * Audio_Avg_Len ;
  
          SIG_L_pre = SIG_L_last ;
          SIG_R_pre = SIG_R_last ;
          for (int i=0; i<Audio_Avg_Len; i++)
          {
             SIG_L_list[i]=SIG_L_last;
             SIG_R_list[i]=SIG_R_last;
          }
          for (int i=0; i<AVG_len; i++)
          {
            Track_Array[i] = 0;
          }
           
          Max_Jump = 2000;
          CORRECT_COUNT = 0;
            
         }
         else{
          if(RAW_COUNT == 3)
          {analogWrite(GROOVE_TRACK_COARSE, 116);
            PAUSE = 0;
          }
          RAW_COUNT ++;
         }
        }

        if(p.y/750 == (FORW_X/64))
        {/*AUDIO_ON = 1;
         CTRL_ON = 0;
         PLAY_MODE = 0;
         PAUSE = 0;
         BACK_PRESSED = 1;
         analogWrite(GROOVE_TRACK_COARSE, 256);*/
         AUDIO_ON = 1;
         CTRL_ON = 1;
         PLAY_MODE = 0;
         FORW_PRESSED = 1;
       //  last_kp = Kp;
       //  Kp = 0;
         if(RAW_COUNT > 10)
         {
          RAW_COUNT = 0;
          PAUSE = 1;
          //RESET_CTRL();
          analogWrite(GROOVE_TRACK_COARSE, 0);
          analogWrite(GROOVE_TRACK_PIN_P, 0);
          analogWrite(GROOVE_TRACK_PIN_N, 0);
          Track_Sum = 0;
          NO_SIG_COUNT = 0;
          G_Tracking_Inti = 0;
          Groove_Width = 6000;
          SIG_L_last = (MIRROR_TIME / 2);
          SIG_R_last = (MIRROR_TIME / 2);
          SIG_L_Sum =(SIG_L_last) * Audio_Avg_Len ;
          SIG_R_Sum =(SIG_R_last) * Audio_Avg_Len ;
  
          SIG_L_pre = SIG_L_last ;
          SIG_R_pre = SIG_R_last ;
          for (int i=0; i<Audio_Avg_Len; i++)
          {
             SIG_L_list[i]=SIG_L_last;
             SIG_R_list[i]=SIG_R_last;
          }
          for (int i=0; i<AVG_len; i++)
          {
            Track_Array[i] = 0;
          }
           
          Max_Jump = 2000;
          CORRECT_COUNT = 0;
            
         }
         else{
          if(RAW_COUNT == 3)
          {analogWrite(GROOVE_TRACK_COARSE, 116);
            PAUSE = 0;
          }
          RAW_COUNT ++;
         }
        }
       }
        else if((p.x/950) > 0){
        if((p.y/750) == (VOL_X/64)){
          float Volume = (VOL_Y + 124 - (float)p.x/16)/112.0;
          if(Volume > 1)
           {
            Volume = 1;
           }
          else if(Volume < 0)
           {
            Volume = 0;
           }

           if(EQ_MODE == 0)
           {Draw_Vol(Volume);
            sgtl5000_1.volume(Volume);
            global_volume = Volume;
           }
           else if(EQ_MODE == 1)
           {Draw_Vol(Volume);
           
            global_bass = Volume*2.0 - 1.0;
           //  sgtl5000_1.eqSelect(2);
           // sgtl5000_1.eqBands(global_bass, global_treble);
              sgtl5000_1.eqSelect(3);
              sgtl5000_1.eqBand(1, global_bass);
              sgtl5000_1.eqBand(2, global_bass);
           //   sgtl5000_1.eqBand(3, 0.8);
           //   sgtl5000_1.eqBand(4, global_treble);
            //  sgtl5000_1.eqBand(5, global_treble+0.3);
            
           }
           else if(EQ_MODE == 2)
           {Draw_Vol(Volume);
             global_treble = Volume*2.0 - 1.0;
              //sgtl5000_1.eqSelect(2);
              //sgtl5000_1.eqBands(global_bass, global_treble);
              sgtl5000_1.eqSelect(3);
             // sgtl5000_1.eqBand(1, global_bass);
             // sgtl5000_1.eqBand(2, global_bass);
             // sgtl5000_1.eqBand(3, 0.8);
              sgtl5000_1.eqBand(4, global_treble);
              sgtl5000_1.eqBand(5, global_treble+0.3);
           }
        }
        
       }
    
 /*   tft.fillRect(100, 150, 140, 60, ILI9341_BLACK);
    tft.setTextColor(ILI9341_GREEN);
   // tft.setFont(Arial_24);
    tft.setTextSize(3);
    tft.setCursor(100, 150);
    tft.print("X = ");
    tft.print(p.x);
    tft.setCursor(100, 180);
    tft.print("Y = ");
    tft.print(p.y);*/
   /* Serial.print(", x = ");
    Serial.print(p.x);
    Serial.print(", y = ");
    Serial.println(p.y);*/
  } else {
    if (wastouched) {
    //  tft.begin();
  //    tft.SPI_Init();
  //    tft.fillScreen(ILI9341_BLACK);
  //    tft.setTextColor(ILI9341_RED);
    //  tft.setFont(Arial_48);
   //   tft.setTextSize(4);
   //   tft.setCursor(120, 50);
   //   tft.print("No");
    //  tft.setCursor(80, 120);
    //  tft.print("Touch");
    //  ts.begin();
    if (BACK_PRESSED)
      {
       BACK_PRESSED = 0;
       RAW_COUNT = 255;
       AUDIO_ON = 1;
       CTRL_ON = 1;
       PLAY_MODE = 0;
       PAUSE = 0;
       Draw_Back(ILI9341_GREEN);
      }
     else if (FORW_PRESSED)
      {
       FORW_PRESSED = 0;
       RAW_COUNT = 255;
       AUDIO_ON = 1;
       CTRL_ON = 1;
       PLAY_MODE = 0;
       PAUSE = 0;
       Draw_Forw(ILI9341_GREEN);
      }
     else
     {
        Draw_Next(ILI9341_BLUE);
        Draw_Prev(ILI9341_BLUE);
        Draw_Land(ILI9341_GREEN);
        Draw_Edge(ILI9341_ORANGE);
        Draw_Reset(ILI9341_RED);
     }
    }
   // Serial.println("no touch");
   }
    wastouched = istouched;
    // Serial.println('C');
    //use serial to emulate press button
      if(Serial.available())
      {char cmd ;
       cmd=Serial.read();
       if(cmd == 'a')
       {
        Serial.println(CORRECT_COUNT);
        Serial.println(NO_SIG_COUNT);
        
       }
       else if(cmd == 'n')
       {
         Serial.println(nulls);
       }
       else if(cmd == 'E')
       {
        audio_enhancer = 1;
        sgtl5000_1.audioPostProcessorEnable();
      //  sgtl5000_1.eqSelect(2);
      //  sgtl5000_1.eqBands(-0.5, 0.6);
      // sgtl5000_1.audioPostProcessorEnable();
        sgtl5000_1.eqSelect(3);
     
        sgtl5000_1.eqBand(1, -0.6);
        sgtl5000_1.eqBand(2, -0.6);
        sgtl5000_1.eqBand(3, 0.6);
        sgtl5000_1.eqBand(4, 0.7);
        sgtl5000_1.eqBand(5, 1.0);
        
       }
       else if(cmd == 'D')
        {
        audio_enhancer = 0;
        sgtl5000_1.audioProcessorDisable();
        }
        else if(cmd == 'P')
        {
          PLAY_MODE = 0;
          start_reset = 0;
          analogWrite(GROOVE_TRACK_COARSE, 116);
        }
        else if(cmd == 'N')
        {
          PLAY_MODE = 3;
          start_reset = 0;
        }
        else if(cmd == 'B')
        {
          PLAY_MODE = 4;
          start_reset = 0;
        }
        else if(cmd == 'R')
        {
          PLAY_MODE = 5;
          start_reset = 0;
        }
        else if(cmd == 'L')
        {
          PLAY_MODE = 6;
          start_reset = 0;
        }
        else if(cmd == 'I')
        {
          DISC_TYPE = 1;
        }
        else if(cmd == 'O')
        {
          DISC_TYPE = 2;
        }
        else if(cmd == 'V')
        {
          DISC_TYPE = 0;
        }
        else if(cmd == 'G')
        {
          DEGLITCH = 0;
        }
         else if(cmd == 'S')
        {
          DEGLITCH = 1;
        }
        else if(cmd == 'F')
        {
           AVG_len = 8;
           Kp = 800;    
           Kd =50;
           Ki = 18;    
           K_shift = 23;
        }
        else if(cmd == 'H')
        { AVG_len = 512;
          Kp = 10;      
          Kd = 350;
          Ki = 12;    
          K_shift = 22;
          
        }
        else if(cmd == 'T')
        {
          sgtl5000_1.audioProcessorDisable();
        }

       if(PLAY_MODE == 0)
       {
        CTRL_ON = 1;
       }
      else if((PLAY_MODE == 1) || (PLAY_MODE == 2))
       {
        CTRL_ON = 0;
       }
      else
       {
        CTRL_ON = 0;
       }
       }

     
     
    }
 
      delayMicroseconds(5);
   
  
    
 //   digitalWrite(28,1);
 //   if(Serial.available())
  //  {
      /*
    }
      char cmd ;
     cmd=Serial.read();
     if(cmd == 'a')
     {
      Serial.println(CORRECT_COUNT);
      Serial.println(NO_SIG_COUNT);
      
     }
     else if(cmd == 'E')
     {
      audio_enhancer = 1;
      sgtl5000_1.audioPostProcessorEnable();
      sgtl5000_1.eqSelect(3);
   
      sgtl5000_1.eqBand(1, -0.5);
      sgtl5000_1.eqBand(2, 0.3);
      sgtl5000_1.eqBand(3, 0.6);
      sgtl5000_1.eqBand(4, 0.8);
      sgtl5000_1.eqBand(5, 1.0);
     }
     else if(cmd == 'D')
     {
      audio_enhancer = 0;
      sgtl5000_1.audioProcessorDisable();
     }
     */
  //  }
    

   if(dead_count>>15)
   {
    STATE_CHECK=65535;
    dead_count = 0;
    PAUSE = 1;
    analogWrite(GROOVE_TRACK_COARSE,256);
    Set_Mirr_Freq();
    Draw_GUI();
    setI2SFreq((MIRR_FREQ*2 ));
    analogWriteFrequency(GROOVE_TRACK_PIN_P, MIRR_FREQ*2);
    analogWriteFrequency(GROOVE_TRACK_PIN_N, MIRR_FREQ*2);
    analogWriteFrequency(GROOVE_TRACK_COARSE,MIRR_FREQ*4);

    analogWrite(GROOVE_TRACK_PIN_P, 0);
    analogWrite(GROOVE_TRACK_PIN_N, 0);
  
    analogWrite(GROOVE_TRACK_COARSE, 116);


    
    attachInterrupt(SIG_PIN_R, sig_rise_irq, RISING);
    attachInterrupt(SIG_PIN_F, sig_fall_irq, FALLING);
    ts.begin();
    }
    dead_count++;
  }



  /*
    int knob = analogRead(A2);
    float vol = (float)knob / 1280.0;
    sgtl5000_1.volume(vol);
    //Serial.print("volume = ");
    //Serial.println(vol);
  */
}



void lsync_rise_irq() {
  // Serial.println("lsync_rise");
  //   delay(5000);
  lsync_rise_frame = ARM_DWT_CYCCNT;
  //   MIRROR_TIME = lsync_rise_frame - rsync_rise_frame;
  //lsync_done = 0;
  //if SIG_LTR_i is not 0 here, the signal is not read, too fast mirror frequency
  
  DIR_LTR = 1;
 // sig_fall_irq();
 // SIG_RTL[SIG_RTL_i & SIG_BUFF_MASK] = SIG_RTL[(SIG_RTL_i-1) & SIG_BUFF_MASK];
//  SIG_RTL_i++;
//  SIG_RTL_i_b = SIG_RTL_i - 1;
  //SIG_LTR_i = 0;
  CLEAR_LTR = 1;
  if(FEEDBACK_DRIVE)
  {
    digitalWriteFast(MIRR_CLK,0);
  }
}

void lsync_fall_irq() {
  //Serial.println("lsync_fall");
  //  delay(5000);
  lsync_fall_frame = ARM_DWT_CYCCNT;
  lsync_start_raw = ML_Bias + lsync_rise_frame + ((lsync_fall_frame - lsync_rise_frame) >> 1) ;
  //  rsync_end_frame = lsync_start_frame;
  split_sync = lsync_start_raw + lsync_start_raw  - rsync_start_raw ;
  lsync_done = 1;

  DIR_LTR = 2;
  if(CLEAR_LTR)
      {
        SIG_LTR_i = 0;
        //lsync_start_frame = split_sync; //use predicted start frame if the measured one is not available
        CLEAR_LTR = 0;
      }
 // t1->begin(ProcessAudioControl, 1);
  t1.trigger(0);
}
void rsync_rise_irq() {
  //Serial.println("rsync_rise");
  // delay(5000);
  rsync_rise_frame = ARM_DWT_CYCCNT;
  //  MIRROR_TIME = rsync_rise_frame - lsync_rise_frame;
  //rsync_done = 0;
  //if SIG_RTL_i is not 0, the signal is not read, too fast mirror frequency
  DIR_LTR = 3;
 // sig_fall_irq();
//  SIG_LTR[SIG_LTR_i & SIG_BUFF_MASK] = SIG_LTR[(SIG_LTR_i-1) & SIG_BUFF_MASK];
 // SIG_LTR_i++;
 // SIG_LTR_i_b = SIG_LTR_i-1;
 // SIG_RTL_i = 0;
  CLEAR_RTL = 1;
  if(FEEDBACK_DRIVE)
  {
    digitalWriteFast(MIRR_CLK,1);
  }
}
void rsync_fall_irq() {
  // Serial.println("rsync_fall");
  //   delay(5000);
  //cli();
  rsync_fall_frame = ARM_DWT_CYCCNT;
  //sei();
  rsync_start_raw = MR_Bias + rsync_rise_frame + ((rsync_fall_frame - rsync_rise_frame) >> 1);
  //   lsync_end_frame = rsync_start_frame;
  split_sync = rsync_start_raw + rsync_start_raw  - lsync_start_raw ;
  rsync_done = 1;
  DIR_LTR = 0;
   if(CLEAR_RTL)
      {
        SIG_RTL_i = 0;
        //rsync_start_frame = split_sync; //use predicted start frame if the measured one is not available
        CLEAR_RTL = 0;
      }
// t1->begin(ProcessAudioControl, 1);
  t1.trigger(0);
}



void sig_rise_irq() {
  // Serial.println("sig_rise");
  // delay(5000);
  Time_Reader_r = ARM_DWT_CYCCNT;
  switch(DIR_LTR)
  {
  // cli();
   case(2): 
    SIG_LTR[SIG_LTR_i ] = Time_Reader_r;// - lsync_start_frame;
    SIG_LTR_R[SIG_LTR_i ] = 1;
    SIG_LTR_i++;
   // sei();
   break;
   case(0):
  //cli();
    SIG_RTL[SIG_RTL_i ] = Time_Reader_r;// - rsync_start_frame;
    SIG_RTL_R[SIG_RTL_i] = 1;
    SIG_RTL_i++;
   // sei();
   break;
    case(1):
    if ((int)(Time_Reader_r - split_sync) < 0) //split the lsync
    {
      SIG_RTL[SIG_RTL_i] = Time_Reader_r;// - rsync_start_frame;
      SIG_RTL_R[SIG_RTL_i] = 1;
      SIG_RTL_i++;
    }
    else
    { //DIR_LTR = 2;
      if(CLEAR_LTR)
      {
        SIG_LTR_i = 0;
        //lsync_start_frame = split_sync; //use predicted start frame if the measured one is not available
        CLEAR_LTR = 0;
      }
      SIG_LTR[SIG_LTR_i] = Time_Reader_r;// - lsync_start_frame;
      SIG_LTR_R[SIG_LTR_i] = 1;
      SIG_LTR_i++;
    }
    break;
    case(3):  
    if ((int)(Time_Reader_r - split_sync) < 0) //split the rsync
    {
      SIG_LTR[SIG_LTR_i] = Time_Reader_r;// - lsync_start_frame;
      SIG_LTR_R[SIG_LTR_i] = 1;
      SIG_LTR_i++;
    }
    else
    { //DIR_LTR = 0;
      if(CLEAR_RTL)
      {
        SIG_RTL_i = 0;
        //rsync_start_raw = split_sync; //use predicted start frame if the measured one is not available
        CLEAR_RTL = 0;
      }
      SIG_RTL[SIG_RTL_i] = Time_Reader_r;// - rsync_start_frame;
      SIG_RTL_R[SIG_RTL_i] = 1;
      SIG_RTL_i++;
    }
    break;
  }
}
void sig_fall_irq() {
  // Serial.println("sig_fall");
  // delay(5000);
  
  Time_Reader_f = ARM_DWT_CYCCNT;
  switch(DIR_LTR)
  {
   case 2:
  //cli();
    SIG_LTR[SIG_LTR_i] = Time_Reader_f;// - lsync_start_frame;
    SIG_LTR_R[SIG_LTR_i] = 0;
    SIG_LTR_i++;
   // sei();
   break;
   

   case 0:

  //cli();
    SIG_RTL[SIG_RTL_i] = Time_Reader_f;// - rsync_start_frame;
    SIG_RTL_R[SIG_RTL_i] = 0;
    SIG_RTL_i++;
    //sei();
   break;

   case(1):
    if ((int)(Time_Reader_f - split_sync) < 0) //split the lsync
    {
      SIG_RTL[SIG_RTL_i] = Time_Reader_f;// - rsync_start_frame;
      SIG_RTL_R[SIG_RTL_i] = 0;
      SIG_RTL_i++;
    }
    else
    { //DIR_LTR = 2;
      if(CLEAR_LTR)
      {
        SIG_LTR_i = 0;
        //lsync_start_raw = split_sync; //use predicted start frame if the measured one is not available
        CLEAR_LTR = 0;
      }
      SIG_LTR[SIG_LTR_i] = Time_Reader_f;// - lsync_start_frame;
      SIG_LTR_R[SIG_LTR_i] = 0;
      SIG_LTR_i++;
    }
    break;

    case (3):
    if ((int)(Time_Reader_f - split_sync) < 0) //split the rsync
    {
      SIG_LTR[SIG_LTR_i] = Time_Reader_f;// - lsync_start_frame;
      SIG_LTR_R[SIG_LTR_i] = 0;
      SIG_LTR_i++;
    }
    else
    { //DIR_LTR = 0;
      if(CLEAR_RTL)
      {
        SIG_RTL_i = 0;
        //rsync_start_raw = split_sync; //use predicted start frame if the measured one is not available
        CLEAR_RTL = 0;
      }
      SIG_RTL[SIG_RTL_i] = Time_Reader_f;// - rsync_start_frame;
      SIG_RTL_R[SIG_RTL_i] = 0;
      SIG_RTL_i++;
    }
    break;
   }
  
}
