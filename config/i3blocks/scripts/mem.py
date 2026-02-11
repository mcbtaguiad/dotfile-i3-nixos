#!/usr/bin/env python3
import psutil
perc=int(psutil.virtual_memory().percent)
print(perc,'%',sep='')
