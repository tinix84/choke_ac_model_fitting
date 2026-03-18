# Choke AC Model Fitting

MATLAB routine to fit impedance measurements from an LCR meter to an AC equivalent circuit (spice model) for power inductors/chokes.

## What It Does

Given impedance vs. frequency measurements of a choke, this tool fits the data to an equivalent circuit model that can be used directly in SPICE simulators. Useful for accurate EMC filter and converter simulations.

## Contents

| File | Description |
|:-----|:------------|
| `runme.m` | Main script — loads data and runs the fitting |
| `f_Zeq.m` | Equivalent impedance model function |
| `importfileHP_excel.m` | Import helper for HP/Keysight LCR meter exports |
| `importfileWK_excel.m` | Import helper for Wayne Kerr LCR meter exports |

## Measurement Data

Includes sample measurements for 120 uH chokes from different manufacturers:
- `Kaschke_120uH.csv`
- `Simon_120uH.csv`
- `Sirio_120uH.csv`

## Usage

1. Place your LCR measurement CSV in the root directory
2. Edit `runme.m` to point to your data file
3. Run `runme.m` in MATLAB
4. The fitted model parameters are printed to the console

## License

See [LICENSE](LICENSE).
