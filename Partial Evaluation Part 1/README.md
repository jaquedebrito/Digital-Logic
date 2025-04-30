I2C Decoder (dec_i2c)

This module implements a simple I2C decoder that receives SDA and SCL signals to detect an I2C communication, processing the device address and operation (read/write). The module is implemented with a finite state machine (FSM) that manages the communication in a robust and efficient manner.
Purpose

The purpose of this module is to monitor the I2C communication, detect START and STOP conditions, and capture the address and operation (read/write). It also generates control signals and can generate the STOP signal when the communication is finished.
Inputs

    clk: Clock signal, used to synchronize the operations.

    reset: Asynchronous reset signal that resets the FSM state.

    sda: Data line of the I2C bus.

    scl: Clock line of the I2C bus.

    pronto: Control signal that indicates when the FSM can finish the STOP operation.

    endereco_local: 7-bit address of the local device, used to identify if the communication is intended for the current device.

Outputs

    endereco_recebido: 7-bit address received during the I2C communication.

    operacao: Indicates whether the operation is a read or write (R/W bit).

    escrita: Control signal that is activated when the operation is a write.

    stop: Signal that indicates the end of the communication when the STOP condition is detected.

Finite State Machine (FSM)

The FSM is implemented with the following states:

    IDLE: Waiting state. The FSM waits for the START condition (when SDA goes low while SCL is high).

    ADDR: During this state, the FSM captures the 7 bits of the device address. On each rising edge of SCL, the SDA bit is stored in the shift register (shift_reg). After 7 bits are received, the FSM transitions to the next state.

    OP: The FSM captures the operation bit (R/W) and determines whether the communication is intended for the local device by comparing the received address to the endereco_local. If the operation is a write (SDA == 0), the escrita signal is activated.

    ACK: After the address and operation are received, the FSM waits for a rising edge of SCL to move to the DONE state.

    DONE: The FSM checks if the STOP condition has been detected (a transition of SDA from low to high while SCL is high). If the pronto signal is active, the STOP signal is generated, and the FSM returns to the IDLE state.

START and STOP Condition Detection

The detection of the START and STOP conditions is performed by checking transitions in the SDA signal while SCL is high. The internal logic detects these conditions and updates the FSM states accordingly.

    START: Detected when SDA goes from high to low while SCL is high.

    STOP: Detected when SDA goes from low to high while SCL is high.

How the Code Works
Edge Detection and START/STOP Conditions

    The code monitors transitions in SDA and SCL signals to detect the START and STOP conditions.

    When a START condition is detected, the code moves to the ADDR state and begins capturing the device address.

    When a STOP condition is detected, the FSM generates the STOP signal and returns to the IDLE state, waiting for the next transaction.

State Transitions

The FSM transitions between states based on the clock signal (clk) and the defined logical conditions. On each clock cycle:

    The state changes based on events like the rising edge of SCL, the detection of START and STOP conditions, and bit counting.

    In the ADDR state, the FSM stores the address bits and moves to the next state after 7 bits are received.

    In the OP state, the code checks the operation (read or write) and if the address matches the local device, activating the write signal if necessary.

    The ACK state waits for a rising edge of SCL to transition to the DONE state.

    The DONE state ends the communication and returns to the IDLE state if the STOP condition is satisfied.

State Diagram

          +---------+
          |  IDLE   |
          +---------+
               |
               |  START
               v
          +---------+
          |  ADDR   |
          +---------+
               |
               |  7 bits received
               v
          +---------+
          |   OP    |
          +---------+
               |
               |  Check address and operation
               v
          +---------+
          |   ACK   |
          +---------+
               |
               |  Wait for SCL
               v
          +---------+
          |  DONE   |
          +---------+
               |
               |  STOP
               v
          +---------+
          |  IDLE   |
          +---------+

Conclusion

This module is designed to efficiently and robustly operate in an I2C communication context, decoding the address and operation of the message. The FSM controls the sequence of states, ensuring that the communication is processed correctly. The use of a finite state machine allows precise control of the communication signals, and the detection of START and STOP conditions ensures that the I2C protocol is followed correctly.
Usage Instructions

    Compile the code using a tool like Quartus or ModelSim to verify the functionality of the FSM.

    Test the I2C communication by connecting the module to an I2C bus and monitoring the outputs (endereco_recebido, operacao, escrita, stop) to check the response to the control signal.

    Use the pronto signal to indicate when the device can generate the STOP signal.
