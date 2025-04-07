# ASIP Stepper Motor Controller

## Overview
This project implements an Application-Specific Instruction-set Processor (ASIP) designed to control a stepper motor using a custom 8-bit RISC instruction set. The processor architecture includes a datapath, control logic, and a set of tailored instructions optimized for stepper motor operations.

## Features
- Custom 8-bit RISC instruction set tailored for motor control  
- Modular datapath design (ALU, registers, control unit)  
- Instruction execution for step/direction control  
- Simulation support

## Instruction Set
The processor supports a small, efficient instruction set tailored to stepper motor control. Instructions are passed through the datapath and executed in a single-cycle fashion.

The instruction encoding is as follows:
![Instruction Set](./photos/instruction_set.png)

## Finite State Machine (FSM)

The controller uses a hardwired finite-state machine to manage instruction sequencing and execution. The FSM has distinct states for:

1. **RESET**: Initializes PC and clears all registers.
2. **FETCH**: Loads the instruction from memory.
3. **DECODE & OPERAND FETCH**: Decodes opcode and fetches operands.
4. **EXECUTE**: Executes arithmetic/logic/motor control logic.
5. **WRITEBACK / CONTROL**: Updates register file or stepper motor output.
6. **BRANCH / DELAY**: Handles conditional branching and delay counter execution for timing-sensitive instructions.

Special attention is given to multi-cycle instructions like `MOVR` and `MOVRHS`, which execute over multiple FSM states, update the TEMP register, and conditionally start the delay counter. 

![FSM Diagram](./photos/FSM.png)

## Datapath Architecture

The datapath is designed to execute a custom 8-bit instruction set tailored for stepper motor control. The design is modular and supports arithmetic, logic, and control operations in a single-cycle execution model. Key components include:

- **Instruction Memory**: Stores program instructions; addressed by the Program Counter (PC).
- **Register File**: Three general-purpose registers (RF[0] to RF[2]) and one delay register (RF[3]).
- **ALU**: Performs arithmetic operations like addition, subtraction, and stepper motor direction logic.
- **Operand Multiplexers**: Dynamically select inputs to the ALU (PC, immediate, register values).
- **TEMP Register**: Holds intermediate values for instructions such as `MOVR` and `MOVRHS`.
- **Stepper ROM**: Outputs 4-bit stepper control signals based on the state in the instruction execution.
- **Result Multiplexer**: Selects the destination of ALU or ROM output for register write-back or motor control.

The datapath is fully controlled by a centralized FSM, with each instruction's behavior determined by opcode decoding and control signal activation.

![FSM Diagram](./photos/datapath.png)
