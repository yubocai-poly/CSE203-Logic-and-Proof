(* ====================================================================
 * We start by loading a few libraries and declaring some
 * propositional variables.
 * ==================================================================== *)

Require Import ssreflect.

Parameter A B C D : Prop.

(* ====================================================================
 * Introducing the "move" tactic
 * ==================================================================== *)

(* `move` allows giving a name to the first (top) assumption of
 * the current goal. For example: *)

Lemma move_ex : A -> B -> A.
Proof.
(* Introduce the assumptions `A` & `B` with respective names
 * `hA` and `hB`. *)
move=> hA hB.
Abort.

(* ====================================================================
 * Introducing the "assumption" tactic
 * ==================================================================== *)

(* `assumption` closes a goal when it can be discharged from an
 * assumption. For example: *)

Lemma assumption_ex : A -> B -> A.
Proof.
(* Introduce the assumptions `A` & `B` with respective
 * names `hA` and `hB`. *)
move=> hA hB.
(* The goal can be solved by `hA` *)
(* If the goal is already in your context, you can use the assumption tactic to immediately prove the goal. *)
assumption.
Qed.

(* It is also possible to close the goal by explicitly giving the name
 * of the assumption, using `apply`: *)

Lemma apply_ex : A -> B -> A.
Proof.
(* Introduce the assumptions `A` & `B` with respective names
 * `hA` and `hB`. *)
move=> hA hB.
(* The goal can be solved by `hA` *)
apply hA.
Qed.

(* ====================================================================
 * Some basic propositional reasonning
 * ==================================================================== *)

Lemma ex0 : A -> A.
move => a.
trivial.
Qed.

Lemma ex1 : forall A : Prop, A -> A.
Proof.
move => a.
move => a0.
apply a0.
Qed.
  
Lemma ex2 : (A -> B) -> (B -> C) -> A -> C.
Proof.
move => ab.
move => bc.
move => a.
(* Here we prove from backward *)
apply bc.
apply ab.
apply a.
Qed.

Lemma ex3 : (A -> B -> C) -> (B -> A) -> B -> C.
Proof.
move => abc.
move => ba.
move => b.

apply abc.
- apply ba. apply b.
- apply b. 
Qed.

(* ====================================================================
 * With conjunctions
 * ==================================================================== *)

(* examples *)

Lemma demo_conj1 : (A /\ B) -> A.
Proof.
move=> h. 
case: h => [a b]. 
(* For conjuctions we use case: h => [a b] *)
exact a.
Qed.

Lemma demo_conj2 : A -> B -> A /\ B.
Proof.
move=> a b; split.
- trivial.
- trivial.
Qed.

(* your turn *)

Lemma conj_ex1: A /\ B <-> B /\ A.
Proof.
(* We split iff into => and <= situation *)
split.

(* split can also split the assumption into 2 parts *)
(* Case 1 *)
+ move => ab. split.
case: ab => [a b]. (* discuss ab into the case a and case b *)
exact b.
case: ab => [a b].
exact a.

(* Case 2 *)
+ move => ba. split.
case: ba => [b a]. exact a.
case: ba => [b a]. exact b.
Qed.

(* ====================================================================
 * With disjunctions
 * ==================================================================== *)

(* examples *)

Lemma demo_disj1 : A -> A \/ B.
Proof.
move=> a. left. trivial.
Qed.

Lemma demo_disj2 : B -> A \/ B.
Proof.
move=> a. right. trivial.
Qed.

Lemma demo_disj3 : A \/ B -> C.
move=> h. case: h => [a | b].    (* here we use h => [a | b] into 2 parts, gives two subgoals *)
Abort.

(* Your turn *)

Lemma disj_ex1 :  A \/ B <-> B \/ A.
Proof.
split. (* We seperate into 2 cases and prove => and <= *)

+ move => ab. 
case: ab => [a | b].
right. trivial. (* We here use right to consider the right situation of A \/ B *)
left. trivial.

+ move => ba.
case: ba => [a | b].
right. trivial.
left. trivial.
Qed.

Lemma disj_ex2 : A /\ B -> A \/ B.
Proof.
move => ab.
case: ab => [a b]. 
right. trivial.
Qed.

(* ====================================================================
 * For negations.
 * ==================================================================== *)

Print not.  (* not A (or ~A) is a shorthand for (A -> False) *)

(* examples *)

Lemma demo_not1 : False -> A.
Proof.
(* We can prove any goal from False *)
move=> h. case: h.
Qed.

(* Your turn *)

Lemma not_ex1 : A -> ~(~A).
Proof.
move => a.
move => not_a.
apply not_a.
apply a.
Qed.

Lemma not_ex2 :  (A -> B) -> ~B -> ~A.
Proof.
move => ab. 
move => not_b.
move => a.

apply not_b. (* Here not_b is false *)
apply ab.
apply a.
Qed.

Lemma not_ex3 : ~ ~(A \/ ~A).
Proof.
move => h.
apply h.
right.
move => a.
apply h.
left.
apply a.
Qed.

Lemma not_ex4 :  (A \/ B) /\ C <-> (A /\ C) \/ (B /\ C).
Proof. 
split. (* split the lemma into two direction *)

+ move => abc. 
case: abc => [ab c].
case: ab => [a | b].
left. split. apply a. apply c.
right. split. apply b. apply c.

+ move => acbc.
case: acbc => [ac | bc].
case: ac => [a c].
split. left. apply a. apply c.
case: bc => [b c].
split. right. apply b. apply c.
Qed.

Lemma not_ex5 : (A /\ B) \/ C <-> (A \/ C) /\ (B \/ C).
Proof.
split.

+ move => abc.
split.
case: abc => [ab | c].
case: ab => [a b].
left. apply a. 
right. apply c.

case: abc => [ab | c].
case: ab => [a b].
left. apply b. 
right. apply c.

+ move => acbc.
case: acbc => [ac bc].
case: ac => [a | c].
case bc => [b | c].
left. split. apply a. apply b.
right. apply c.
right. apply c.
Qed.
