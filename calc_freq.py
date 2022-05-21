if __name__ == "__main__":
    counter_bit_length = int(input("Counter Bit length (change state): "))
    clock_freq = int(input("Clock frequency (HZ):"))


    change_count = pow(2, counter_bit_length)
    duration_state = change_count/clock_freq
    period = duration_state * 2
    frequency = 1/period

    print("Change state every counter: ", change_count)
    print("duration of a state (on/off) (s): ", duration_state)
    print("period, complete cycle (s): ", period)
    print("frequency (hz): ", frequency)