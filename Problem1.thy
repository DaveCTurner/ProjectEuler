theory ProjectEulerProblem1
  imports Main
  begin





function fib :: "nat => nat"
  where "fib 0 = 0"
  | "fib 1 = 1"
  | "fib (Suc (Suc n)) = fib n + fib (Suc n)"
proof -
  fix P x
  assume 0: "x = 0 ==> P" and 1: "x = 1 ==> P" and n: "!!n. x = Suc (Suc n) ==> P"
  have "x = 0 | x = 1 | x > 1" by auto
  thus P
  proof (elim disjE)
    assume gt: "1 < x"
    show P
    proof (intro n)
      from gt 
      show "x = Suc (Suc (x - 2))" by auto
    qed
  qed (auto simp: 0 1)
qed auto

termination
proof
  show "wf less_than" by simp
qed auto

constdefs sumR :: "nat list => nat"
  "sumR == %ns. foldr (op +) ns 0"

lemma sumR_append:
  shows "sumR (a @ b) = sumR a + sumR b"
  by (induct a, auto simp: sumR_def)

constdefs sum :: "nat list => nat"
  "sum == foldl (op +) 0"

lemma sumL: "sumR = sum"
  by (intro ext, simp add: sum_def sumR_def foldl_foldr1)

lemma sum_append[simp]: "sum (a @ b) = sum a + sum b"
using sumR_append by (simp add: sumL)

lemma sum_Nil[simp]: "sum [] = 0" by (simp add: sum_def)

lemma sum_Cons[simp]: "sum (a # as) = a + sum as"
  by (fold sumL, auto simp: sumR_def)

lemma sum_linear_map: "!!f. [| f 0 = 0; !!a b. f (a + b) = f a + f b |]
  ==> sum (map f xs) = f (sum xs)"
  by (induct xs, auto)

consts seq :: "nat => nat list"
primrec 
  "seq 0 = []"
  "seq (Suc n) = (seq n) @ [n]"

lemma seq_append: 
  fixes m n
  shows "seq (m + n) = seq m @ (map (op + m) (seq n))"
  by (induct n, auto)

lemma seq_length: "length (seq n) = n" by (induct n, auto)
lemma seq_set: "set (seq n) = {0..<n}"
proof (induct n)
  case 0
  show ?case by simp
next
  case (Suc n')
  have "set (seq (Suc n')) = insert n' (set (seq n'))" by simp
  also have "... = insert n' {0..<n'}" by (simp only: Suc)
  also have "... = {0..<Suc n'}" by auto
  finally show ?case .
qed
lemma seq_distinct: "distinct (seq n)"
  by (intro card_distinct, simp add: seq_length seq_set)

lemma fib_sum:
  fixes n
  shows "sum (map fib (seq (n+1))) = fib (n+2) - 1"
proof (induct n)
  case 0
  have "fib 1 = 1" by (simp only: fib.simps)
  thus ?case by (auto simp: sum_def)
qed (auto simp: sum_def)

constdefs triangular :: "nat => nat"
  "triangular n == (n * (n - 1)) div 2"

lemma double_triangular:
  fixes n
  shows "2 * triangular n = n * (n - 1)"
proof -
  have "n mod 2 < 2" by auto
  hence "n = 0 | (n > 0 & (n mod 2 = 0 | n mod 2 = 1))" by auto
  hence is_even: "n * (n - 1) mod 2 = 0"
  proof (elim disjE conjE)
    assume "n = 0" thus ?thesis by simp
  next
    assume n: "0 < n"
    {
      assume "n mod 2 = 0"
      then obtain k where k: "n = 2 * k" by (auto simp add: mod_eq_0_iff)
      with n have "k > 0" by auto
      then obtain k' where k': "k = Suc k'" by (cases k, auto)
      show ?thesis
      proof (simp add: k k' mod_eq_0_iff, intro exI)
	show "6 * k' + 4 * (k' * k') = 2 * (3 * k' + 2 * (k' * k'))" by auto
      qed
    next
      from mod_div_decomp
      obtain m q where q: "q = n mod 2" and m: "m = n div 2" and n: "n = m * 2 + q" .
      assume "n mod 2 = 1"
      with q have q: "q = 1" by simp
      with n have n: "n = 2 * m + 1" by auto
      show ?thesis
      proof (simp add: n mod_eq_0_iff, intro exI)
	show "2 * m + 4 * (m * m) = 2 * (m + 2 * m * m)" by auto
      qed
    }
  qed

  show ?thesis
    by (unfold triangular_def, simp only: mult_div_cancel is_even)
qed

lemma triangular:
  fixes n
  shows "triangular n = sum (seq n)"
proof (induct n)
  case 0 thus ?case by (simp add: sum_def triangular_def)
next
  case (Suc m)
  have "2 * triangular (Suc m) = m * (Suc m)"
    by (simp add: double_triangular)
  also have "... = 2 * m + (m * m - m)" by auto
  also have "... = 2 * m + 2 * triangular m" 
    by (simp add: double_triangular, cases m, auto)
  also have "... = 2 * m + 2 * sum (seq m)" by (simp add: Suc)
  also have "... = 2 * sum (seq (Suc m))" by (simp add: sum_def)
  finally show ?case by simp
qed

consts ordered :: "nat list => bool"
primrec
  "ordered [] = True"
  "ordered (n#ns) = (if (EX n' : set ns. n' < n) then False else ordered ns)"

lemma ordered_append:
  assumes ordered_ns: "ordered ns"
  and ordered_ms: "ordered ms"
  and less: "!!n m. [| n : set ns; m : set ms |] ==> n <= m"
  shows "ordered (ns @ ms)"
  using prems
proof (induct ns)
  case Nil thus ?case by simp
next
  case (Cons n ns')
  show ?case
  proof (cases "EX n':set (ns' @ ms). n' < n")
    case False
    show ?thesis
    proof (simp only: append.simps ordered.simps False if_False, rule Cons)
      from Cons.prems show "ordered ns'" and "ordered ms"
	by (cases "EX n' : set ns'. n' < n", auto)
      fix n' m'
      assume n': "n' : set ns'" and m': "m' : set ms"
      with Cons.prems(3) [of n' m']
      show "n' <= m'" by auto
    qed
  next
    case True
    then obtain n' where n': "n' : set (ns' @ ms)" and lt: "n' < n" ..
    from n' have "n' : set ns' | n' : set ms" by simp
    thus ?thesis
    proof (elim disjE)
      assume "n' : set ms"
      from Cons.prems(3) [of n n'] this lt show ?thesis by auto
    next
      assume "n' : set ns'"
      with lt have "EX n' : set ns'. n' < n" by auto
      with Cons.prems(1) show ?thesis by auto
    qed
  qed
qed

lemma seq_ordered:
  shows "ordered (seq n)"
proof (induct n)
  case 0 thus ?case by simp
next
  case (Suc n')
  show ?case
    by (simp, intro ordered_append Suc, simp_all add: seq_set)
qed

lemma filter_ordered:
  assumes ordered: "ordered ns"
  shows "ordered (filter P ns)"
using ordered
proof (induct ns)
  case Nil thus ?case by simp
next
  case (Cons n ns')
  show ?case
  proof (cases "P n")
    case False with Cons show ?thesis by (cases "EX n' : set ns'. n' < n", auto)
  next
    case True with Cons show ?thesis by (cases "EX n' : set ns'. n' < n", auto)
  qed
qed

lemma map_ordered:
  fixes f ns
  assumes ordered: "ordered ns"
  and monotone: "!!n n'. [| n : set ns; n' : set ns; n <= n' |] ==> f n <= f n'"
  shows "ordered (map f ns)"
using ordered and monotone
proof (induct ns)
  case Nil thus ?case by simp
next
  case (Cons n' ns')

  from Cons.prems(1) have n'min: "!! n''. n'' : set ns' ==> n' <= n''"
    by (cases "EX n'' : set ns'. n'' < n'", auto)

  have p: "~(EX n'':set (map f ns'). n'' < f n')"
  proof (intro notI, elim bexE, simp only: set_map, elim imageE, simp)
    fix n'' assume "f n'' < f n'" and "n'' : set ns'"
    with Cons.prems(2) [of n' n''] n'min show False by auto
  qed
    
  show ?case
  proof (simp only: ordered.simps map.simps if_not_P [OF p], intro Cons.hyps)
    from Cons.prems show "ordered ns'" by (cases "EX n'' : set ns'. n'' < n'", auto)
    fix n1 n2 assume "n1 : set ns'" and "n2 : set ns'" and "n1 <= n2"
    with Cons.prems(2) show "f n1 <= f n2" by auto
  qed
qed

lemma ordered_distinct_eq:
  fixes ns ms
  assumes ordered_ns: "ordered ns"
  and ordered_ms: "ordered ms"
  and distinct_ns: "distinct ns"  
  and distinct_ms: "distinct ms"
  and set_eq: "set ns = set ms"
  shows "ns = ms"
  using prems
proof (induct ns arbitrary: ms)
  case Nil thus ?case by simp
next
  case (Cons n ns' ms0)
  from Cons.prems(5) obtain m ms' where ms0: "ms0 = m # ms'" by (cases ms0, auto)

  from Cons.prems(1) have n_min: "!! n'. n' : set ns' ==> n <= n'"
    by (cases "EX n' : set ns'. n' < n", auto)

  from Cons.prems(2) have m_min: "!! m'. m' : set ms' ==> m <= m'"
    by (cases "EX m' : set ms'. m' < m", auto simp: ms0)

  have nm: "n = m"
  proof (cases rule: linorder_cases [of n m])
    case less
    from Cons.prems(5) have "n = m | n : set ms'" by (auto simp add: ms0)
    with m_min have "m <= n" by auto
    with less show ?thesis by auto
  next
    case greater
    from Cons.prems(5) have "n = m | m : set ns'" by (auto simp add: ms0)
    with n_min have "n <= m" by auto
    with greater show ?thesis by auto
  qed

  have "ns' = ms'"
  proof (intro Cons)
    from Cons.prems(1) show "ordered ns'"
      by (cases "EX n' : set ns'. n' < n", auto)
    from Cons.prems(2) show "ordered ms'"
      by (cases "EX m' : set ms'. m' < m", auto simp: ms0)
    from Cons.prems(3) show "distinct ns'" by auto
    from Cons.prems(4) show "distinct ms'" by (auto simp: ms0)
    show "set ns' = set ms'"
    proof (intro equalityI subsetI)
      fix n' assume n': "n' : set ns'"
      also have "... <= set (n#ns')" by auto
      also from Cons.prems(5) have "... = set (m#ms')" by (simp add: ms0)
      finally have "n' = m | n' : set ms'" by auto
      thus "n' : set ms'"
      proof (elim disjE)
	assume "n' = m"
	with nm n' Cons.prems(3) show ?thesis by auto
      qed
    next
      fix m' assume m': "m' : set ms'"
      also have "... <= set (m#ms')" by auto
      also from Cons.prems(5) have "... = set (n#ns')" by (simp add: ms0)
      finally have "m' = n | m' : set ns'" by auto
      thus "m' : set ns'"
      proof (elim disjE)
	assume "m' = n"
	with nm m' Cons.prems(4) show ?thesis by (auto simp: ms0)
      qed
    qed  
  qed

  with nm show ?case by (simp add: ms0)
qed

lemma triangular_multiples:
  fixes n k
  shows "k * triangular n = sum (filter (op dvd k) (seq (k * n)))"
proof (cases "k = 0")
  case True thus ?thesis by simp
next
  case False
  have "k * triangular n = k * (sum (seq n))" by (simp add: triangular)
  also have "k * sum (seq n) = sum (map (op * k) (seq n))"
    by (intro sym [OF sum_linear_map], auto simp: add_mult_distrib add_mult_distrib2)
  also have "... = sum (filter (op dvd k) (seq (k * n)))"
  proof (intro cong [OF refl, where f = sum])
    show "map (op * k) (seq n) = filter (op dvd k) (seq (k * n))" (is "?ns = ?ms")
    proof (intro ordered_distinct_eq map_ordered filter_ordered
	distinct_filter seq_distinct seq_ordered iffD2 [OF distinct_map] conjI inj_onI)
      show "set (map (op * k) (seq n)) = set (filter (op dvd k) (seq (k * n)))"
	(is "?LHS = ?RHS")
      proof (intro equalityI subsetI)
	fix x
	assume "x : ?LHS"
	with False obtain m where "x = k * m" and "m < n" by (auto simp: seq_set)
	with False show "x : ?RHS"
	  by (auto simp: seq_set)
      next
	fix x
	assume "x : ?RHS"
	hence "k dvd x" and lt: "x < k * n" by (auto simp: seq_set)
	then obtain m where x: "x = k * m" by (auto elim: dvdE)
	with lt have m: "m : set (seq n)" by (auto simp: seq_set)
	from x m image_eqI [of x "op * k" m "set (seq n)"]
	show "x : ?LHS" by simp
      qed
    next
      fix x y::nat
      assume "x <= y" thus "k * x <= k * y" by auto
    next
      fix x y
      assume "k * x = k * y" with False show "x = y" by auto
    qed
  qed
  finally show ?thesis .
qed

lemma inclusionExclusion:
  fixes ns P Q
  assumes distinct_ns: "distinct ns"
  shows "sum (filter P ns) + sum (filter Q ns) =
  sum (filter (%n. P n | Q n) ns) + sum (filter (%n. P n & Q n) ns)"
proof (induct ns)
  case Nil thus ?case by simp
next
  case (Cons n ns')
  have "P n | ~P n" and "Q n | ~Q n" by simp_all
  thus ?case (is "?Psum + ?Qsum = ?disjSum + ?conjSum")
  proof (elim disjE)
    assume P: "P n" and Q: "Q n"
    have Psum: "?Psum = n + sum (filter P ns')" by (simp add: P)
    have Qsum: "?Qsum = n + sum (filter Q ns')" by (simp add: Q)
    have conjSum: "?conjSum = n + sum (filter (%n. P n & Q n) ns')" by (simp add: P Q)
    have disjSum: "?disjSum = n + sum (filter (%n. P n | Q n) ns')" by (simp add: P)
    show ?thesis by (unfold Psum Qsum conjSum disjSum, auto simp: Cons)
  next
    assume P: "P n" and Q: "~Q n"
    have Psum: "?Psum = n + sum (filter P ns')" by (simp add: P)
    have Qsum: "?Qsum = 0 + sum (filter Q ns')" by (simp add: Q)
    have conjSum: "?conjSum = 0 + sum (filter (%n. P n & Q n) ns')" by (simp add: Q)
    have disjSum: "?disjSum = n + sum (filter (%n. P n | Q n) ns')" by (simp add: P)
    show ?thesis by (unfold Psum Qsum conjSum disjSum, auto simp: Cons)
  next
    assume P: "~P n" and Q: "Q n"
    have Psum: "?Psum = 0 + sum (filter P ns')" by (simp add: P)
    have Qsum: "?Qsum = n + sum (filter Q ns')" by (simp add: Q)
    have conjSum: "?conjSum = 0 + sum (filter (%n. P n & Q n) ns')" by (simp add: P)
    have disjSum: "?disjSum = n + sum (filter (%n. P n | Q n) ns')" by (simp add: Q)
    show ?thesis by (unfold Psum Qsum conjSum disjSum, auto simp: Cons)
  next
    assume P: "~P n" and Q: "~Q n"
    have Psum: "?Psum = 0 + sum (filter P ns')" by (simp add: P)
    have Qsum: "?Qsum = 0 + sum (filter Q ns')" by (simp add: Q)
    have conjSum: "?conjSum = 0 + sum (filter (%n. P n & Q n) ns')" by (simp add: P)
    have disjSum: "?disjSum = 0 + sum (filter (%n. P n | Q n) ns')" by (simp add: P Q)
    show ?thesis by (unfold Psum Qsum conjSum disjSum, auto simp: Cons)
  qed
qed

lemma sum_dvd:
  fixes n k
  assumes k0: "0 < k"
  shows "sum (filter (op dvd k) (seq (Suc n))) = k * triangular (Suc (n div k))"
proof -
  from mod_div_decomp
  obtain m q where q: "q = n mod k" and m: "m = n div k" and n: "n = m * k + q" .

  have "k * triangular (Suc (n div k)) = sum (filter (op dvd k) (seq (k * (Suc (n div k)))))"
    by (rule triangular_multiples)
  also have "... = sum (filter (op dvd k) (seq (Suc n)))" (is "sum ?xs = sum ?ys")
  proof (intro cong [where f = "sum", OF refl], fold m, unfold n)
    have "filter (op dvd k) (seq (Suc (m * k + q)))
      = filter (op dvd k) (seq (k * m + (q+1)))" 
      by (intro cong [of "filter (op dvd k)", OF refl] cong [of seq], auto)
    also have "... = filter (op dvd k) (seq (k * m) @ (map (op + (k*m)) (seq (Suc q))))"
      (is "... = ?filter (?as @ ?bs)")
      by (intro cong [of "filter (op dvd k)", OF refl], simp add: seq_append)
    also have "?filter (?as @ ?bs) = (?filter ?as) @ (?filter ?bs)"
      by simp
    also have "(?filter ?as) @ (?filter ?bs) 
      = (?filter ?as) @ (?filter (map (op + (k * m)) (seq k)))"
    proof (intro cong [of "op @ (?filter ?as)", OF refl])
      have singleton: "!!p. [| 0 < p; p <= k |]
	==> (filter (op dvd k) (map (op + (k * m)) (seq p))) = [k * m]"
      proof (intro ordered_distinct_eq filter_ordered distinct_filter
	  iffD2 [OF distinct_map] conjI map_ordered seq_ordered
	  seq_distinct inj_onI)
	
	fix n n'::nat assume "n <= n'" thus "k * m + n <= k * m + n'" by auto
      next
	fix n n' assume "k * m + n = k * m + n'" thus "n = n'" by auto
      next
	show "ordered [k * m]" by simp
	show "distinct [k * m]" by simp
      next
	fix p assume pk: "p <= k" and p0: "0 < p"
	show "set (filter (op dvd k) (map (op + (k * m)) (seq p))) = set [k * m]"
	  (is "?LHS = ?RHS")
	proof (intro equalityI subsetI)
	  fix l assume "l : ?LHS"
	  then obtain r where rp: "r < p" and l: "l = k*m + r" and 
	    kl: "k dvd l"
	    by (simp only: set_filter set_map set.simps seq_set, auto)
	  
	  from kl have "0 = l mod k" by (simp add: dvd_eq_mod_eq_0)
	  also have "l mod k = (r + m * k) mod k"
	    by (unfold l, simp only: nat_add_commute nat_mult_commute)
	  also have "... = r mod k" by simp
	  also have "... = r"
	  proof (intro mod_less)
	    note rp
	    also note pk
	    finally show "r < k" .
	  qed
	  finally have r0: "r = 0" ..
	  from k0 show "l : ?RHS" by (auto simp: seq_set l r0)
	next
	  fix l assume "l : ?RHS"
	  hence l: "l = k * m" by auto
	  with p0 show "l : ?LHS"
	    by (auto simp: seq_set)
	qed
      qed

      have "?filter (map (op + (k * m)) (seq (Suc q))) = [k * m]"
      proof (intro singleton)
	note q
	also note mod_less_divisor [OF k0]
	finally show "Suc q <= k" by simp
      qed simp
      also have "filter (op dvd k) (map (op + (k * m)) (seq k)) = [k * m]"
	by (intro singleton k0, simp)
      finally show "filter (op dvd k) (map (op + (k * m)) (seq (Suc q))) =
	filter (op dvd k) (map (op + (k * m)) (seq k))" by simp
    qed
    also have "... = ?filter (seq (k * m) @ (map (op + (k * m)) (seq k)))" by simp
    also have "... = ?filter (seq (k * m + k))"
      by (intro cong [of "?filter", OF refl], simp add: seq_append)
    also have "... = ?filter (seq (k * Suc m))" 
      by (intro cong [of "?filter", OF refl] cong [of seq, OF refl], auto)
    finally show "filter (op dvd k) (seq (k * Suc m)) = filter (op dvd k) (seq (Suc (m * k + q)))"
      by simp
  qed
  finally show ?thesis ..
qed

lemma projectEuler1_closedForm:
  fixes n
  shows "sum (filter (%m. 3 dvd m | 5 dvd m) (seq (Suc n)))
  = (let n3 = n div 3; n5 = n div 5; n15 = n div 15 in
  3 * (triangular (Suc n3)) + 5 * (triangular (Suc n5)) - 15 * (triangular (Suc n15)))"
proof -
  obtain n3 where n3: "n div 3 = n3" by simp
  obtain n5 where n5: "n div 5 = n5" by simp
  obtain n15 where n15: "n div 15 = n15" by simp

  have "sum (filter (%m. 3 dvd m | 5 dvd m) (seq (Suc n)))
    + sum (filter (%m. 3 dvd m & 5 dvd m) (seq (Suc n)))
    = sum (filter (%m. 3 dvd m) (seq (Suc n))) + sum (filter (%m. 5 dvd m) (seq (Suc n)))"
    by (intro sym [OF inclusionExclusion] seq_distinct)
  hence "sum (filter (%m. 3 dvd m | 5 dvd m) (seq (Suc n)))
    = sum (filter (%m. 3 dvd m) (seq (Suc n))) + sum (filter (%m. 5 dvd m) (seq (Suc n)))
    - sum (filter (%m. 3 dvd m & 5 dvd m) (seq (Suc n)))" 
    (is "?threeOrFives = ?threes + ?fives - ?fifteens") by simp
  also have "... = ?threes + ?fives - sum (filter (%m. 15 dvd m) (seq (Suc n)))"
    (is "?threeOrFives = ?threes + ?fives - ?fifteens")
  proof (intro cong [of "op - (?threes + ?fives)", OF refl]
      cong [of sum, OF refl] filter_cong refl iffI conjI, elim conjE)
    fix x::nat
    assume "15 dvd x" hence p: "(3 * 5) dvd x" by simp
    show "3 dvd x" and "5 dvd x" 
      by (intro dvd_mult_left [OF p], intro dvd_mult_right [OF p])
  next
    fix x::nat
    assume 3: "3 dvd x" and 5: "5 dvd x"

    from mod_div_decomp
    obtain m q where q: "q = x mod 15" and m: "m = x div 15" and x: "x = m * 15 + q" .

    note q
    also note mod_less_divisor
    finally have q15: "q < 15" by simp

    from 3 obtain x3 where x3: "x = 3 * x3" ..
    from 5 obtain x5 where x5: "x = 5 * x5" ..

    from x x3 have "3 * x3 = 3 * 5 * m + q" by simp
    hence "q = 3 * x3 - 3 * 5 * m" by simp
    hence "q = 3 * (x3 - 5 * m)" by simp
    hence "3 dvd q" by simp
    then obtain q3 where q3: "q = 3 * q3" ..
    with q15 have "q3 : {0, 1, 2, 3, 4}" by auto
    with q3 have q3: "q : {0, 3, 6, 9, 12}" by auto

    from x x5 have "5 * x5 = 5 * 3 * m + q" by simp
    hence "q = 5 * x5 - 5 * 3 * m" by simp
    hence "q = 5 * (x5 - 3 * m)" by simp
    hence q5: "5 dvd q" by simp
    then obtain q5 where q5: "q = 5 * q5" ..
    with q15 have "q5 : {0, 1, 2}" by auto
    with q5 have q5: "q : {0, 5, 10}" by auto
    
    from q3 q5 have "q = 0" by auto
    with x have "x = 15 * m" by auto
    thus "15 dvd x" by simp
  qed
  also have "... = (let n3 = n div 3; n5 = n div 5; n15 = n div 15
    in 3 * triangular (Suc n3) + 5 * triangular (Suc n5) - 15 * triangular (Suc n15))"
    by (simp only: n3 n5 n15 Let_def sum_dvd)
  finally show ?thesis .
qed

lemma projectEuler1:
  shows "sum (filter (%m. 3 dvd m | 5 dvd m) (seq (Suc 999))) = 233168"
  by (unfold projectEuler1_closedForm, simp add: triangular_def)

end