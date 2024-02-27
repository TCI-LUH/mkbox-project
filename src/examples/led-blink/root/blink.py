import gpiod;
import time;

consumer = "test"

## Create a button on pin 7 and set it to falling edge mode.
button = gpiod.find_line("PIN_7")
button.request(consumer, gpiod.LINE_REQ_EV_FALLING_EDGE)

## Create an LED on pin 36 and set it as an output pin.
led = gpiod.find_line("PIN_36")
led.request(consumer, gpiod.LINE_REQ_DIR_OUT)

## Implement a simple function to wait for a timeout and check if the button is pressed, then blink three times quickly.
def is_button_pressed(timeout):
    event = button.event_wait(int(timeout), int((timeout % 1) *1000*1000))
    if event:
        button.event_read()
        for i in range(0,3):
            led.set_value(1)
            time.sleep(0.1)
            led.set_value(0)
            time.sleep(0.1)

## Continuously loop and blink slowly.
while True:
    led.set_value(1)
    is_button_pressed(1)
    led.set_value(0)
    is_button_pressed(1)