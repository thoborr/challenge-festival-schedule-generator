# challenge-festival-schedule-generator
A simple MATLAB function to generate the festival schedule, outputting to the command window and as a nice figure.
It maximises the gap between performances where possible, giving the roadies as much time as possible for the changeovers

To run:
```
make_planning('example_input.txt')
```

Where example_input.txt is a space-seperated list of [show_name start_hour end_hour] as per the challenge description.
