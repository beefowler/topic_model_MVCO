#!/usr/bin/env python
# Let's try to generate multiple outputs for topic model 

import os, subprocess 

def run_model(alph, bet, k):
  pname="res_a%.2f_b%.2f_k%d" % (alph, bet, k)
  if not os.path.exists(pname):
      print('making directory', pname)
      os.mkdir(pname)
  os.chdir(pname)
  popen= subprocess.Popen( "topics.refine.t --in.words=../Blast1_wordlist.csv --iter=100 --alpha=%f --beta=%f --vocabsize=657 -K %d --g.time 3 --cell.time 10" % (alph, bet, k), shell=True, stdout=subprocess.PIPE)
  os.chdir("..")


def main():

  alpha_vals=[0.1, 0.5, 1, 1.5]
  beta_vals=[0.1, 0.5, 1, 1.5]
  for a in alpha_vals:
    for b in beta_vals:
       run_model(a, b, 6)



if __name__ == "__main__":
  main()

