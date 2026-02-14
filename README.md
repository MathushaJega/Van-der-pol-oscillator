# Van der Pol Oscillator (Verilog Implementation)

This project implements a digital **Van der Pol Oscillator** on an FPGA using Verilog. It solves the non-linear differential equation numerically using the **Finite Difference Method (Euler Method)** to generate a stable limit cycle oscillation.

## 📌 Project Overview
The Van der Pol oscillator is a non-conservative oscillator with non-linear damping. This implementation discretizes the system into time steps ($dt$) and calculates the next position ($x$) and velocity ($u$) based on the current state.

### Key Features
* **Modular Design**: Separated into `Datapath`, `Control Unit` (FSM), and `Top Module`.
* **Finite State Machine (FSM)**: 4-state control logic to sequence mathematical operations (Square -> Damping -> Velocity -> Position).
* **Fixed-Point Arithmetic**: Uses scaled integer math (multiplying by 1024 to represent $1.0$) for efficient FPGA implementation without floating-point units.
* **Full Cycle Simulation**: Validated in Xilinx Vivado with a testbench running for 10ms to capture the complete limit cycle.

## 📂 File Structure
* `top_module.v` - Connects the Control Unit and Datapath.
* `control_unit.v` - FSM that directs the sequence of calculations.
* `datapath.v` - Performs the arithmetic operations (multiplication, addition, integration) using signed registers.
* `vdp_tb.v` - Testbench that generates the clock, reset, and logs output data to `results.txt`.

## 📊 Parameters
* **Mu (μ) **: 1.0 (Damping coefficient)
* **Time Step (dt)**: 0.1
* **Initial Condition(x₀)**: 1.0
