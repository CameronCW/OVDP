#define PD_A_pin 1
#define PD_B_pin 3
 
#define Focus_P_pin 8
#define Focus_N_pin 9
 
 
int Focus_Err = 0;
int Focus_Err_l = 0;
int I = 0;
int D = 0;
int F = 0;
int Fl = 0;
 
int Set_Point = -20;
 
#define AVG_len 400
 
int16_t Focu_Err_l [AVG_len] = {0};
uint16_t AVG_RC = 0;
 
int Sum = 0;
int Sum_l=0;
int16_t voltage = 0;
 
uint8_t pwm_delay = 0;
#define pwm_delay_max  1
bool NO_DISC = 0;
uint32_t disc_detect_count = 0;
uint32_t Release_Count = 0;
bool TEST_MODE = 0;
void setup() {
  // declare the ledPin as an OUTPUT:
  pinMode(Focus_P_pin, OUTPUT);  
  pinMode(Focus_N_pin, OUTPUT); 
  pinMode(PD_A_pin, INPUT_PULLDOWN);  
  pinMode(PD_B_pin, INPUT_PULLDOWN); 
  analogReadResolution(8);
}
char tmp;
 
void loop() {
 
 
if(!TEST_MODE)
{
  if(Serial.available())
  {
  /*   tmp = (int)Serial.read();
     Set_Point = tmp + 550;*/
     Set_Point = Serial.parseInt();
     Serial.println(Set_Point);
     if(Set_Point == 1025)
     {  Serial.println("Enter open loop test mode? Y/N");
        while(!Serial.available())
         {
         }
        tmp = Serial.read();
        if(tmp == 'Y')
        {
          TEST_MODE = 1;
          Serial.println("Start Testing");
        }
     }
  }
  voltage = (analogRead(PD_A_pin));
  if(voltage > 1000)
  { 
    if(disc_detect_count < 10000)
    {disc_detect_count++;}
    else
    {NO_DISC = 1;
     I = 0;
     D= 0;
      Sum = 0;
     for(int i = 0; i< AVG_len; i++ )
     {
      Focu_Err_l[i]=0;
     }
    }
  }
  else
  {disc_detect_count = 0;
   NO_DISC = 0;
  }
if(!NO_DISC)
{
  //Focus_Err = Set_Point - voltage ;  
//  Focus_Err = analogRead(PD_B_pin) - Set_Point; 
    // Focus_Err = analogRead(PD_B_pin) - voltage+Set_Point ;  
    Focus_Err = ((185-voltage ) << 6)  ;  //setpoint to 0, 190 as the max
  //analogRead(PD_A_pin);
//Serial.println(Set_Point);
Focu_Err_l[AVG_RC] =  Focus_Err;
AVG_RC += 1;
if(AVG_RC >= AVG_len)
{
  AVG_RC = 0;
}
D=Focus_Err - Focu_Err_l[AVG_RC];
Sum = Sum + D  ;
 
//Focus_Err = Sum/AVG_len;
 
  
if((F <= (int)(2000000)) && (Fl >= (int)(-2000000)))
// if((F <= (int)(200000)) && (Fl >= (int)(-200000)))
  {
    I = I + Focus_Err;  
    Release_Count=0;         
  }
  else if((Fl < (int)(-2000000)) && (Focus_Err >= 0))
  // else if((Fl < (int)(-200000)) && (Focus_Err >= 0))
  {
    I = I + Focus_Err;
    Release_Count=0; 
  }
  else if((Fl > (int)(2000000)) && (Focus_Err <= 0))
  // else if((Fl > (int)(200000)) && (Focus_Err <= 0))
  {
    I = I + Focus_Err;
    Release_Count=0; 
  }
  else
  {if(Release_Count>50000)
  
    {
     /* I = 0;
      Sum = 0;
      D= 0;
     for(int i = 0; i< AVG_len; i++ )
     {
      Focu_Err_l[i]=0;
     }
     */
      Release_Count = 0;
    }
    else
    {
      Release_Count++;
    }
  }
 
 
  //D=Focus_Err-Focus_Err_l;
  // D=Sum-Sum_l;
// F = (Sum * 10) + ( I * 10 ) + (D * 0);
Fl = (Sum * 50) + ( I * 1) + (D * 0);
// F += (Fl)>>7;
F += (Fl)>>11; 

// Serial.println(F ); 
pwm_delay += 5;
if(pwm_delay >= pwm_delay_max)
{pwm_delay=0;
  F=F/pwm_delay_max;
  if(F>=0)
  {
    pwm(Focus_N_pin ,12000,  0);
    pwm(Focus_P_pin ,12000 , F);

 
  //  analogWrite(Focus_P_pin , F >> 2);
  //  analogWrite(Focus_N_pin ,  0);
   // TCC1->COUNT8.CTRLA.reg = REG_TCC1_PER & B11111000 | B00000001;
  }
  else if(F<(0))
  {
    pwm(Focus_P_pin ,12000,0);
    pwm(Focus_N_pin ,12000, (-F));
 
   // analogWrite(Focus_P_pin ,0);
  //  analogWrite(Focus_N_pin , (-F) >> 2); 
  }
F=0;
}
  Focus_Err_l = Focus_Err;
  Sum_l = Sum;
}
else
{
    pwm(Focus_P_pin ,12000,0);
    pwm(Focus_N_pin ,12000, 0); 
}
}
else
{if(Serial.available())
  {
  /*   tmp = (int)Serial.read();
     Set_Point = tmp + 550;*/
     F = Serial.parseInt();
      if(F>=0)
     {
       pwm(Focus_N_pin ,12000,  0);
       pwm(Focus_P_pin ,12000 , F);
 
    
     }
     else if(F<(0))
     {
       pwm(Focus_P_pin ,12000,0);
       pwm(Focus_N_pin ,12000, (-F));
 
     }
     delay(500);
      Serial.print(F);
      Serial.print(',');
      Serial.print(analogRead(PD_A_pin));
      Serial.print(',');
      Serial.println(analogRead(PD_B_pin));
 
     if(F == 1025)
     {  Serial.println("Enter close loop mode? Y/N");
        while(!Serial.available())
        {
        }
        tmp = Serial.read();
        if(tmp == 'Y')
        {
          TEST_MODE = 0;
        }
     }
  }
}
}
