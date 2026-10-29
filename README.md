# Classical extremal graph theory beyond Mathlib

[![CI](https://github.com/Egly443/lean-graph-extremal/actions/workflows/ci.yml/badge.svg)](https://github.com/Egly443/lean-graph-extremal/actions/workflows/ci.yml)

A Lean 4 library of classical graph theory that Mathlib lacks:
- the Motzkin–Straus theorem with Turán's and Mantel's bounds;
- Zykov's clique-count theorem, sharp at the Turán graph;
- Kőnig's theorem and Gallai's identity;
- lexicographic products of graphs;
- Paley graphs.

It is a **Mathlib-ready strawman**, written to Mathlib's conventions and offered for reuse as is,
by people and by AI systems. Anyone in the Mathlib community may upstream it, in whole or in part,
if and when they choose. The author does not plan to drive it through Mathlib review.

**Provenance:** AI-generated with human guidance. Every file:

* builds with no `sorry` and no warnings;
* uses only the standard axioms (`propext`, `Classical.choice`, `Quot.sound`);
* passes Mathlib's `#lint`, `runLinter` and `lint-style`, and the `linter.mathlibStandardSet`
  linters;
* depends only on Mathlib;
* meets [LeanPool](https://github.com/LeanPool/lean-pool)'s content rules (file headers, no
  waivers or `set_option`).

Licensed under Apache 2.0.

## Using it

The library is pinned to Lean and Mathlib `v4.35.0-rc3` (see `lean-toolchain` and
`lakefile.toml`). To depend on it, add to your `lakefile.toml`:

```toml
[[require]]
name = "graph_extremal"
git = "https://github.com/Egly443/lean-graph-extremal"
rev = "main"
```

and `import GraphExtremal`, or import individual modules such as `GraphExtremal.Paley`. To build
it, run `lake exe cache get` and then `lake build`.

Releases are tagged `vX.Y.Z` from `main` by the manually triggered `Release` workflow
(`.github/workflows/release.yml`).

## Contents

| File | Main results |
|---|---|
| `GraphExtremal/Extremal/WeightShifting.lean` | `SimpleGraph.exists_isClique_support_le`: if `f` is convex along every direction `Pi.single u 1 - Pi.single v 1` with `u, v` non-adjacent, every nonnegative weighting is dominated by one with the same total weight supported on a clique. `exists_isClique_support_le_of_affine`: the same for `f` affine along those directions. |
| `GraphExtremal/Extremal/MotzkinStraus.lean` | The Motzkin–Straus theorem in Mathlib's matrix language. If `G` has no `(r + 1)`-clique, `p ⬝ᵥ G.adjMatrix ℝ *ᵥ p ≤ (1 - 1 / r) * (∑ i, p i) ^ 2` for `p ≥ 0`. Equality holds for the uniform weighting of an `r`-clique, and the maximum over the standard simplex `{p \| 0 ≤ p ∧ ∑ i, p i = 1}` is `1 - 1 / G.cliqueNum` (`isGreatest_dotProduct_adjMatrix_mulVec`). The uniform weighting gives Turán's theorem, at most `(1 - 1 / r) * n ^ 2 / 2` edges (`card_edgeFinset_le_of_cliqueFree`), and Mantel's theorem (`four_mul_card_edgeFinset_le_of_cliqueFree_three`). |
| `GraphExtremal/Extremal/Zykov.lean` | **Zykov's theorem**: a graph on `n` vertices with no `(r + 1)`-clique has at most `r.choose s * (n / r) ^ s` cliques of size `s` (`card_cliqueFinset_le_choose_mul_div_pow`), with the weighted form for `SimpleGraph.cliqueWeight G s p` (`cliqueWeight_le_choose_mul`). Also Maclaurin's inequality `∑ S ∈ T.powersetCard s, ∏ i ∈ S, x i ≤ (#T).choose s * ((∑ i ∈ T, x i) / #T) ^ s` for `x ≥ 0` (`Finset.sum_powersetCard_prod_le`), which Mathlib lacks. The bound is attained by the Turán graph (`card_cliqueFinset_turanGraph`). |
| `GraphExtremal/Konig.lean` | **Kőnig's theorem** for Mathlib's `IsBipartiteWith`: a finite bipartite graph has a matching and a vertex cover of the same size (`IsBipartiteWith.exists_isMatching_isVertexCover`), so the largest matching has `G.vertexCoverNum` edges (`exists_isMatching_ncard_edgeSet_eq_vertexCoverNum`). Weak duality `Subgraph.IsMatching.ncard_edgeSet_le` holds in any graph, with only the cover assumed finite. **Gallai's identity** `α(G) + τ(G) = n` (`indepNum_add_vertexCoverNum`), hence `ν(G) + α(G) ≤ n` in general (`Subgraph.IsMatching.ncard_edgeSet_add_indepNum_le`) and `α(G) = n - ν(G)` for bipartite graphs (`IsBipartiteWith.exists_isMatching_ncard_edgeSet_add_indepNum`). |
| `GraphExtremal/LexProd.lean` | `SimpleGraph.lexProd G H`, the lexicographic product (Harary's composition `G[H]`), with its embeddings, `G □ H ≤ G.lexProd H` and `compl_lexProd`. If `G` has no `(m + 1)`-clique and `H` no `(n + 1)`-clique, `G.lexProd H` has no `(m * n + 1)`-clique (`CliqueFree.lexProd`), and likewise for independent sets. For finite graphs `cliqueNum_lexProd` and `indepNum_lexProd` give exact products, and `chromaticNumber_lexProd_le` bounds `χ` by `χ(G) * χ(H)`. Blowing up each vertex of `G` into `m` independent vertices multiplies the number of `s`-cliques by `m ^ s` (`card_cliqueFinset_lexProd_bot`); the Turán graph `T(m * r, r)` is the blow-up of `K_r` (`topLexProdBotIsoTuranGraph`), so it has exactly `r.choose s * m ^ s` cliques of size `s` (`card_cliqueFinset_turanGraph`). Degrees and edges: `degree_lexProd`, `card_edgeFinset_lexProd` (`\|E(G)\| * \|β\| ^ 2 + \|α\| * \|E(H)\|`). Associativity: `lexProdAssoc`. Also `Iso.card_cliqueFinset_eq`. |
| `GraphExtremal/Paley.lean` | `SimpleGraph.paleyGraph F` for a field `F`. For a finite field with `q ≡ 1 [MOD 4]` elements: strongly regular with parameters `(q, (q - 1) / 2, (q - 5) / 4, (q - 1) / 4)` (`paleyGraph_isSRGWith`); isomorphic to its complement (`paleyGraphComplIso`), so `indepNum = cliqueNum`; cliques have at most `√q` vertices (`cliqueNum_paleyGraph_sq_le`). It has diameter `2` and is connected (`paleyGraph_ediam_eq_two`, `paleyGraph_connected`), and the affine maps `x ↦ a * x + b` with `a` a nonzero square are automorphisms (`paleyGraphAffineIso`), transitive on vertices and on ordered edges. Also `quadraticChar_sum_mul_add` (`∑ x, χ x * χ (x + a) = -1` for `a ≠ 0`) and the general `Embedding.cliqueNum_le`, `Iso.cliqueNum_eq`. |

Motzkin–Straus and Zykov are corollaries of one weight-shifting lemma. The Motzkin–Straus form
and the weighted clique count are each affine along non-edge directions, so the extremum is
attained on a clique. There, the bound is Cauchy–Schwarz for Motzkin–Straus and Maclaurin's
inequality for Zykov. Design choices are explained in each file's implementation notes.

## Notes for anyone upstreaming to Mathlib

* **Layout.** `GraphExtremal/Extremal/` holds the files that would go to
  `Mathlib/Combinatorics/SimpleGraph/Extremal/`, next to `Extremal/Turan.lean`. `Konig.lean`,
  `LexProd.lean` and `Paley.lean` would go directly under `Mathlib/Combinatorics/SimpleGraph/`,
  beside `Matching.lean`, `Prod.lean` and `StronglyRegular.lean`.
* **Lemmas that belong elsewhere.** `Finset.sum_powersetCard_prod_le` (Maclaurin's inequality,
  top-versus-bottom form) belongs in `Mathlib/Analysis/MeanInequalities.lean` or next to
  `Multiset.esymm`. Its proof is an induction on the index set with Bernoulli's inequality at each
  step, so it needs neither Newton's inequalities nor calculus. `quadraticChar_sum_mul_add`
  belongs in `Mathlib/NumberTheory/LegendreSymbol/QuadraticChar/`, and `Embedding.cliqueNum_le`,
  `Iso.cliqueNum_eq` and `Iso.card_cliqueFinset_eq` in `Clique.lean`.
* **Names.** `card_cliqueFinset_le` is already taken in Mathlib (the bound `(card α).choose n`),
  hence `card_cliqueFinset_le_choose_mul_div_pow`. The special case `s = r` keeps the names
  `cliqueWeight_le` and `card_cliqueFinset_le_div_pow`.
* **Overlap with Mathlib.** `card_edgeFinset_le_of_cliqueFree` overlaps Mathlib's
  `CliqueFree.card_edgeFinset_le`, which is the exact bound by the Turán number. It is kept as the
  Motzkin–Straus route to Turán; an upstreamer may prefer to drop it.
* **Matching number.** Mathlib has no matching number, so Kőnig is stated as "some matching has
  `vertexCoverNum` edges", which with weak duality says `ν(G) = τ(G)`. Defining
  `matchingNumber` (as an `sSup`, like `cliqueNum`) is a design choice left to an upstreamer; every
  statement here then becomes an equation in `ν`.
* **Paley graphs.** The graph is defined with `fromRel`, so it needs no hypothesis; for
  `q ≡ 3 [MOD 4]` it is complete, and the results assume `IsSquare (-1 : F)`.
* **Older Mathlib.** The code was developed against an older Mathlib (the `v4.31` era) as well and
  builds warning-free on both. Keeping both working explains a few choices:
  * `IsClique.card_le_cliqueNum` changed its clique argument from implicit to explicit, so it is
    called with named arguments.
  * Mathlib `v4.35` deprecates the set-valued `stdSimplex` in favour of the bundled
    `Convexity.StdSimplex`, so the simplex is written out as `{p | 0 ≤ p ∧ ∑ i, p i = 1}`. An
    upstreamer may restate it with `StdSimplex`.
  * Newer Lean deprecates `if_pos`/`if_neg`, so the proofs use `simp` with `↓reduceIte`.
  * Mathlib `v4.35` renamed `Finset.prod_le_prod`, so `Zykov.lean` proves the product comparison
    it needs by a three-line induction.

## Relation to other libraries

* None of these results is in Mathlib. Zykov's theorem, Maclaurin's inequality, lexicographic
  products and Paley graphs are also absent from [LeanPool](https://github.com/LeanPool/lean-pool)
  and TauCeti.
* LeanPool already contains a Motzkin–Straus inequality, as the supporting lemma
  `BollobasNikiforov.motzkinStraus` in the `bollobas-nikiforov` project. That version bounds the
  form by `1 - 1 / ω(G)` using its own simplex. This library adds a standalone Mathlib-style API:
  the `CliqueFree` form, the equality case, the `IsGreatest` characterisation and the general
  weight-shifting lemma.
* LeanPool already contains Kőnig–Egerváry, as `Konig.Egervary.exists_matching_card_eq_vertexCover`
  in the `classical-matching-factors` project (imported from `jtraverso/konig-edge-colouring`).
  That version assumes `G.Colorable 2` and `Finite V`, also for weak duality. This library states
  the theorem for Mathlib's `IsBipartiteWith`, proves weak duality for infinite `V` with a finite
  cover, and adds the equality with Mathlib's `vertexCoverNum` and Gallai's identity.
* LeanPool has a Paley tournament (`block-spectral-sensitivity`) and a Paley adjacency operator
  inside `common-neighbour-conjecture`, but no Paley graph API.
* The Ramsey consequences belong with Ramsey numbers, in
  [lean-ramsey](https://github.com/Egly443/lean-ramsey): lexicographic products give the product
  inequality `R(pq + 1) - 1 ≥ (R(p + 1) - 1) * (R(q + 1) - 1)`, and Paley graphs give `R(k, k) > q`
  once `k ^ 2 > q`.

## Citation

The mathematics is from the works below. BibTeX entries for Mathlib's `docs/references.bib` are in
`references.bib`. Each was checked against zbMATH or the Jahrbuch (JFM), carries its identifier,
and the file is normalised with the `bibtool` command from Mathlib's `scripts/lint-bib.sh`.

* T. S. Motzkin, E. G. Straus, *Maxima for graphs and a new proof of a theorem of Turán*,
  Canad. J. Math. 17 (1965), 533–540, doi:10.4153/CJM-1965-053-6.
* P. Turán, *Eine Extremalaufgabe aus der Graphentheorie*, Mat. Fiz. Lapok 48 (1941), 436–452.
* W. Mantel, *Vraagstuk XXVIII*, Wiskundige Opgaven 10 (1907), 60–61.
* A. A. Zykov, *On some properties of linear complexes*, Mat. Sb. (N.S.) 24(66) (1949), 163–188.
* G. H. Hardy, J. E. Littlewood, G. Pólya, *Inequalities*, 2nd ed., Cambridge University Press,
  1952.
* D. Kőnig, *Graphok és matrixok*, Mat. Fiz. Lapok 38 (1931), 116–119.
* J. Egerváry, *Matrixok kombinatorius tulajdonságairól*, Mat. Fiz. Lapok 38 (1931), 16–28.
* O. Ore, *Graphs and matching theorems*, Duke Math. J. 22 (1955), 625–639,
  doi:10.1215/S0012-7094-55-02268-7.
* T. Gallai, *Über extreme Punkt- und Kantenmengen*, Ann. Univ. Sci. Budapest. Eötvös Sect. Math.
  2 (1959), 133–138.
* F. Harary, *Graph theory*, Addison-Wesley, 1969.
* X. Xu, Z. Xie, G. Exoo, S. P. Radziszowski, *Constructive lower bounds on classical multicolor
  Ramsey numbers*, Electron. J. Combin. 11 (2004), R35. They attribute the product inequality to
  Abbott's 1965 thesis, which could not be consulted.
* R. E. A. C. Paley, *On orthogonal matrices*, J. Math. Phys. 12 (1933), 311–320,
  doi:10.1002/sapm1933121311.
* C. Godsil, G. Royle, *Algebraic graph theory*, Graduate Texts in Mathematics 207, Springer, 2001.
