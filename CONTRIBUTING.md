# Contributing to Digital Logic Projects

Thank you for your interest in contributing to this repository! This document provides guidelines for contributing to the Digital Logic projects.

## 🎯 Project Goals

This repository serves as a collection of educational projects for learning digital logic design using SystemVerilog and Cadence tools. Contributions should align with these educational objectives.

## 🤝 How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:

1. Check if the issue already exists in the [Issues](https://github.com/jaquedebrito/Digital-Logic/issues) section
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - SystemVerilog code snippets if applicable
   - Simulation/synthesis tool versions

### Suggesting Enhancements

Enhancement suggestions are welcome! Please include:

- Clear description of the proposed feature
- Rationale for why it would be valuable
- Example use cases
- Potential implementation approach

### Code Contributions

#### Before You Start

1. Fork the repository
2. Create a new branch for your feature: `git checkout -b feature/your-feature-name`
3. Ensure you have the required tools installed:
   - Cadence Xcelium (or compatible simulator)
   - Cadence Genus (for synthesis projects)

#### Coding Standards

**SystemVerilog Style:**
- Use meaningful signal and module names
- Include comprehensive comments for complex logic
- Follow existing code style and formatting
- Use proper indentation (2 or 4 spaces, be consistent)
- Add module headers with description, inputs, and outputs

**Example Module Header:**
```systemverilog
//==============================================================================
// Module: module_name
// Description: Brief description of module functionality
//
// Inputs:
//   clk    - System clock
//   reset  - Active high reset
//   din    - Data input
//
// Outputs:
//   dout   - Data output
//   valid  - Output valid signal
//==============================================================================
```

**Testbench Requirements:**
- Include comprehensive test cases
- Test corner cases and edge conditions
- Add meaningful assertions and checks
- Include waveform generation
- Document expected vs actual results

#### Documentation

All new projects or significant modifications should include:

1. **README.md** in the project directory containing:
   - Project overview and objectives
   - Module specifications (inputs/outputs)
   - Implementation details
   - State diagrams (for FSMs)
   - Simulation results
   - Usage instructions

2. **Inline comments** for:
   - Complex logic blocks
   - State machine transitions
   - Critical timing constraints
   - Non-obvious design decisions

3. **Waveform screenshots** showing:
   - Successful test cases
   - Key signal transitions
   - Annotated important events

#### Commit Guidelines

- Write clear, descriptive commit messages
- Use present tense ("Add feature" not "Added feature")
- Reference issue numbers when applicable
- Keep commits focused and atomic

**Good commit message examples:**
```
Add 8x1 multiplexer with hierarchical design
Fix timing issue in traffic light FSM
Update I2C decoder documentation with state diagram
Add testbench for bus arbiter module
```

#### Testing

Before submitting:

1. **Simulate** your design:
   ```bash
   xrun -sv your_module.sv your_testbench.sv
   ```

2. **Check** for:
   - Successful compilation
   - All tests passing
   - No timing violations
   - Proper waveform generation

3. **Synthesis** (if applicable):
   - Ensure design is synthesizable
   - Check for synthesis warnings
   - Review area/power reports

4. **Document** simulation results:
   - Capture relevant waveforms
   - Include in project README
   - Explain any anomalies

#### Pull Request Process

1. Update documentation to reflect your changes
2. Add simulation results and waveforms
3. Ensure all tests pass
4. Update the main README if adding a new project
5. Create pull request with:
   - Clear title describing the change
   - Detailed description of what was changed and why
   - References to related issues
   - Screenshots of simulation results
   - Any synthesis reports (if applicable)

**Pull Request Template:**
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Performance improvement

## Testing
- [ ] Simulation passes
- [ ] Synthesis successful (if applicable)
- [ ] Waveforms captured
- [ ] Documentation updated

## Screenshots
[Attach waveform screenshots]

## Additional Notes
Any additional context or information
```

## 📋 Project Structure

When adding new projects:

```
Project_Name/
├── README.md                 # Project documentation
├── module_name.sv            # Main design file
├── module_name_tb.sv         # Testbench
├── run_sim.sh               # Simulation script (optional)
├── waveform.pdf             # Waveform screenshot
└── schematic.pdf            # Schematic (if applicable)
```

## 🔍 Code Review

All submissions require review. Reviewers will check:

- Code quality and style adherence
- Completeness of documentation
- Testbench coverage
- Simulation results validity
- Synthesis feasibility (for synthesizable designs)

## ✅ Acceptance Criteria

Your contribution will be accepted if:

1. ✓ Code follows SystemVerilog best practices
2. ✓ Design is properly documented
3. ✓ Testbench demonstrates correct functionality
4. ✓ Simulation results are included
5. ✓ No simulation/synthesis errors or warnings
6. ✓ Contribution aligns with educational goals

## 📚 Resources

- [SystemVerilog Tutorial](https://www.chipverify.com/systemverilog/systemverilog-tutorial)
- [Cadence Xcelium Documentation](https://www.cadence.com/en_US/home/tools/system-design-and-verification/simulation-and-testbench-verification/xcelium-simulator.html)
- [Digital Design Best Practices](https://zipcpu.com/tutorial/)

## ❓ Questions?

If you have questions about contributing:

1. Check existing issues and pull requests
2. Review project documentation
3. Open a new issue with the `question` label

## 🙏 Thank You!

Your contributions help make this repository a valuable learning resource for digital logic design!

---

**Note:** This is an educational repository. While all contributions are appreciated, priority is given to changes that enhance the learning experience and maintain code quality.
