# Synthetic cerebral oxygenation signals for preterm infants

This code generates a synthetic cerebral oxygenation signal (rcSO<sub>2</sub>). This is meant to be
similar to the real rcSO<sub>2</sub> acquired by near infrared spectroscopy (NIRS). These signals are
specific to preterm infants born <32 weeks of gestation and include transient-like
events. Full details can be found in:

`JM O' Toole, EM Dempsey, and GB Boylan "Extracting transients from cerebral oxygenation
signals of preterm infants: a new singular-spectrum analysis method", Int. Conf. IEEE
Eng. Med. Biol. Society (EMBC), Honolulu, HI; IEEE, July 2018.`
   
Please cite the above reference if using this code to generate new results. 

# Requirements
Matlab (R2017 or newer, [Mathworks](http://www.mathworks.co.uk/products/matlab/)) with the
signal processing toolbox or Octave (v4.2.1 or newer, [GNU
Octave](https://www.gnu.org/software/octave/)) with the signal package (v1.3.2).

# Use
Set paths in Matlab/Octave, or do so using the `load_curdir` function:
```matlab
  >> load_curdir;
```

Generate 10 rcSO<sub>2</sub> synthetic signals:
```matlab
  >> dur=12*3600; Fs=1/6;
  >> x_st=signal_test_transient_NIRS(dur, Fs, 10);
```

# Licence

```
Copyright (c) 2018, John M. O' Toole, University College Cork
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

  Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

  Redistributions in binary form must reproduce the above copyright notice, this
  list of conditions and the following disclaimer in the documentation and/or
  other materials provided with the distribution.

  Neither the name of the University College Cork nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
```

# References

1. JM O' Toole, EM Dempsey, and GB Boylan "Extracting transients from cerebral oxygenation
   signals of preterm infants: a new singular-spectrum analysis method", Int. Conf. IEEE
   Eng. Med. Biol. Society (EMBC), Honolulu, HI; IEEE, July 2018.


# Contact

John M. O' Toole

Neonatal Brain Research Group,  
INFANT: Irish Centre for Fetal and Neonatal Translational Research,  
Department of Paediatrics and Child Health,  
Room 2.19 Paediatrics Bld, Cork University Hospital,  
University College Cork,  
Ireland

- email: j.otoole AT ieee.org

