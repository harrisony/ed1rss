/* Copyright (c) 2011 Harrison Conlin <me@harrisony.com>
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/
#include <Messenger.h>
#include <LiquidCrystal.h>

Messenger message = Messenger(); 
LiquidCrystal lcd(6,7,8,2,3,4,5);

const int latchPin = 11;
const int clockPin = 10;
const int dataPin = 12;
void message_handler(){
    while (message.available()){
        lcd.print(message.readInt());
    }     
}


void waiting(){
    lcd.print("Waiting");
    while(!((Serial.available() > 0) && (Serial.read() == 6))){
        Serial.print(5,BYTE);
        delay(100); 
    }
    write_leds(0);
    lcd.clear();
    lcd.print("Ready");
}   
void write_leds(byte value){
    digitalWrite(latchPin, LOW);
    shiftOut(dataPin, clockPin, MSBFIRST, value);  
    digitalWrite(latchPin, HIGH);
}
void setup(){
    Serial.begin(115200);
    lcd.begin(16, 2);
    pinMode(latchPin, OUTPUT);
    pinMode(clockPin, OUTPUT);
    pinMode(dataPin, OUTPUT);
    message.attach(message_handler);
    write_leds(0x81);
    waiting();

}

void loop(){
    while (Serial.available()) message.process(Serial.read());
}

