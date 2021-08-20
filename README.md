# Polynomial Multiplier Hardware for CRYSTALS-KYBER

Hardware implementation of polynomial multiplication operation of CRYSTALS-KYBER PQC scheme (the implementations are for academic research only and does not come with any support or any responsibility.)

Paper: https://ieeexplore.ieee.org/abstract/document/9474139

# Files

The repo includes the following files:
<ul>
<li>pe1 - Hardware implementation with 1 butterfly unit</li>
  <ul>
    <li><code>KyberHPM1PE.v</code> - top module</li>
    <li><code>KyberHPM1PE_test_ALL_FULL.v</code> - testbench for full polynomial multiplication</li>
    <li><code>KyberHPM1PE_test_ALL_HALF.v</code> - testbench for half polynomial multiplication</li>
    <li><code>KyberHPM1PE_test_FNTT.v</code> - testbench for forward NTT operation</li>
    <li><code>KyberHPM1PE_test_INTT.v</code> - testbench for inverse NTT operation</li>
    <li><code>KyberHPM1PE_test_PWM2.v</code> - testbench for coefficient-wise multiplication operation</li>
  </ul>
<li>pe4 - Hardware implementation with 4 butterfly units</li>
<li>pe16 - Hardware implementation with 16 butterfly units</li>
<li>test_generator - Generates test vectors for hardware impelementations</li>
  <ul>
    <li><code>test_generator.py</code> - Python code for generating test vectors</li>
    <li>test_pe1 - test vectors for implementation with 1 butterfly unit</li>
    <li>test_pe4 - test vectors for implementation with 4 butterfly units</li>
    <li>test_pe16 - test vectors for implementation with 16 butterfly units</li
  </ul>
</ul>


