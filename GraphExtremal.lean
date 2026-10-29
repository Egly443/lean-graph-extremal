/-
Copyright (c) 2026 Brian Sanders. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Brian Sanders
-/
module

public import GraphExtremal.Extremal.MotzkinStraus
public import GraphExtremal.Extremal.WeightShifting
public import GraphExtremal.Extremal.Zykov
public import GraphExtremal.Konig
public import GraphExtremal.LexProd
public import GraphExtremal.Paley

/-!
# Classical extremal graph theory beyond Mathlib

Imports every module of the library: the weight-shifting lemma
(`GraphExtremal.Extremal.WeightShifting`), the Motzkin–Straus theorem with Turán's and Mantel's
bounds (`GraphExtremal.Extremal.MotzkinStraus`), Zykov's theorem and Maclaurin's inequality
(`GraphExtremal.Extremal.Zykov`), Kőnig's theorem and Gallai's identity (`GraphExtremal.Konig`),
lexicographic products and the Turán graph (`GraphExtremal.LexProd`), and Paley graphs
(`GraphExtremal.Paley`).
-/
