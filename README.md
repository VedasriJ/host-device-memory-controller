# Host–Device Memory Controller (Verilog)

This project is a Verilog implementation of a simple host–device memory controller.  
It handles read operations from an external memory using control logic and internal registers.

The “host” is treated as an external master that provides control signals and reads data through registers.

---

## What the design does

- Accepts read requests from a host
- Stores the requested address
- Reads data from memory using a handshake (`mem_rdy`)
- Buffers the data internally
- Signals completion using a status flag and interrupt

---

## Main blocks

### Host Controller
A finite state machine that:
- Interprets host control signals
- Selects between status, data, and memory access
- Starts a memory read
- Raises an interrupt when the operation finishes

### Device Controller
A finite state machine that:
- Controls memory signals (`mem_cs`, `mem_read`)
- Waits for the memory to become ready
- Enables data capture
- Asserts a `done` signal after completion

### Registers
- **Address Register**: stores the memory address from the host  
- **Data Register**: stores data read from memory  
- **Status Register**: stores completion status for the host  

The registers are controlled using enable signals from the FSMs and share a common host data bus.

---

## How a read works (high level)

1. Host provides an address and asserts read  
2. Address is latched into the address register  
3. Host controller starts the device controller  
4. Device controller performs the memory read  
5. Memory data is stored in the data register  
6. Status is updated and an interrupt is generated  
7. Host reads status and data  

---

## Testbench

The testbench checks:
- Address capture
- Memory ready handshaking
- Data buffering
- Status register behavior
- Interrupt generation

Random addresses and data are used to simulate memory responses.

---

## Limitations

- Single outstanding transaction
- Read-only operation
- No standard bus protocol
- Latch-based registers
- Internal tri-state buses

These were kept for simplicity and clarity.

---

## Possible improvements

- Convert registers to synchronous flip-flops
- Replace tri-state buses with mux logic (FPGA-friendly)
- Add timeout and error handling
- Support write operations

---

## Summary

This project demonstrates a basic memory controller architecture with clear separation between control logic and datapath. It focuses on FSM-based sequencing, register buffering, and simple host–memory coordination.

