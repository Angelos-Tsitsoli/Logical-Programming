# Assignment #1
## Exercise #1
The problem involves sorting 𝑁 circular pies of varying diameters, initially stacked in a random order, into a sorted order where the largest pie (diameter 
𝑁) is at the bottom, the second largest (𝑁−1) is above it, and so on, with the smallest pie (diameter 1) on top.
The pies are stacked on a plate with a diameter of 𝑁+1.

The only allowed operation to rearrange the pies involves using a spatula. The spatula can be placed beneath any pie, lifting it and all the pies above it, and then flipping the entire lifted stack. This effectively reverses the order of the pies above the chosen point. The goal is to find a sequence of such operations that transforms the initial stack into the desired sorted order.
In Prolog, the solution is to define a predicate pancakes_dfs/3 that performs a depth-first search (DFS) to explore all possible sequences of flips. The predicate should:

* Take the initial state of the pie stack as input.
* Return the sequence of operations (a list of pie diameters corresponding to the spatula's position during each flip).
* Return the intermediate states the stack passes through during the solution.

By modeling the problem with DFS, the solution systematically explores all possible flip sequences, backtracking as necessary, to find all valid sequences that sort the stack.


## Exercise #2
The task involves assigning activities to individuals under specific constraints. Each activity is defined as activity(A, act(S,E)), meaning activity A starts at S and ends at E.
Constraints include:

* Each activity is assigned to exactly one person.
* No person can handle overlapping activities.
* There must be at least a 1-time-unit gap between consecutive activities assigned to the same person.
* A person’s total working time cannot exceed a specified limit.

The Prolog predicate assignment/4 assigns activities feasibly, given:

* NP: Number of available individuals
* MT: Maximum total work time per person.
* ASP: A list of 𝑁−𝐴𝑠−𝑇 (person, their activities, total time).
* ASA: A list of 𝐴−𝑁 (activity-to-person assignments).

## Exercise #3
The task involves solving a square crossword puzzle defined by its dimension and the coordinates of black (unusable) cells. Words must fit into horizontal and vertical slots formed by the white cells, avoiding black cells.
In Prolog, the predicate crossword/1 should:

* Take as input a list of available words via words/1.
* Place words into the crossword in order: horizontal slots first, then vertical.
* Return the list of used words in the placement order.
* Print the crossword layout with filled words, representing black cells clearly.

For example:

* With the puzzle defined by dimension(5) and black/2 facts, and words/1 given, the predicate places the words in valid positions while respecting constraints.
* Outputs include a visual representation of the filled crossword and the list of placed words. Only one solution is required, failing if none exists. Words of length 1 are excluded.


# Assignment #2

## Exercise #1
This problem involves dividing the set 𝑆={1,2,3,…,𝑁}
S={1,2,3,…,N}, where 𝑁is an even positive integer, into two disjoint subsets 𝑆1 and 𝑆2 such that:
* ∣𝑆1∣=∣𝑆2∣ (both subsets have the same number of elements).
* ∑𝑆1=∑𝑆2 (the sums of the elements in both subsets are equal).
* $\sum S_1^2 = \sum S_2^2$(the sums of the squares of the elements are also equal).

The Prolog predicate numpart/3 should:
* Take an even integer 𝑁 as input.
* Generate all valid partitions 𝑆1 and 𝑆2 such that the above conditions are satisfied.
* Return these partitions through backtracking.

For example:

* If 𝑁=2 or 𝑁=4, the predicate should return no as no solution exists.
* For 𝑁=8, the predicate should return 𝑆1={1,4,6,7},𝑆2={2,3,5,8}.

## Exercise #2
In propositional logic, a formula is in conjunctive normal form (CNF) if it is a conjunction of disjunctions (clauses), where each clause contains literals (symbols or their negations). For example:
(𝑥1∨¬𝑥2∨𝑥4)∧(¬𝑥1∨𝑥2)∧(¬𝑥1∨¬𝑥2∨𝑥3)
​
The MAXSAT problem seeks to assign true/false values to symbols to maximize the number of satisfied clauses. For example, if no assignment satisfies all clauses, an assignment that satisfies the maximum possible number is sought.
In Prolog:

A CNF formula is a list of lists, where each inner list encodes a clause.
Example:
[[1,−2,4],[−1,2],[−1,−2,3]]
Use the predicate create_formula(NV, NC, D, F) to generate CNF formulas:
* NV: Number of variables.
* NC: Number of clauses.
* D: Density (average % of variables per clause).

Define maxsat/6:

* Input: NV, NC, D.
* Output:
  * F: Generated formula.
  * S: Assignment of 1 (true) or 0 (false) to variables.
  * M: Maximum satisfied clauses.
?- maxsat(5, 7, 40, F, S, M).
F = [[-4, -5], [-3, -4], [2, -3, 4], [-2, -3, -4, 5], [1], [2, -3, 4], [-1, 2, 4]],
S = [1, 0, 1, 1, 0],
M = 6.


## Exercise #3
The Skyscraper puzzle is a grid-based logic game where:

* Each cell in an 𝑁×𝑁 grid contains a skyscraper of height 1 to 𝑁.
* Skyscrapers in a row or column must have unique heights.
* Numbers outside the grid indicate how many skyscrapers are visible from that direction. Taller buildings block shorter ones behind them.
* Some cells may be pre-filled as clues.

For example:
The puzzle is represented with the predicate puzzle/7:

* 1st Argument: Puzzle ID.
* 2nd Argument: Grid size N.
* 3rd/4th Arguments: Visible skyscrapers from the left/right of each row.
* 5th/6th Arguments: Visible skyscrapers from the top/bottom of each column.
* 7th Argument: Grid template with pre-filled values or underscores for unknowns.

puzzle(demo, 5,
 [0,2,0,2,4], [4,0,2,0,0],
 [0,0,0,0,0], [0,3,0,2,0],
 [[_,_,_,_,_],
  [_,_,_,_,_],
  [_,5,_,_,_],
  [_,_,_,_,_],
  [_,_,_,_,_]]).


Task:Define the predicate skyscr/2:

* Input: Puzzle ID.
* Output: Completed grid (solution).

?- skyscr(demo, Solution).
Solution = [[5, 4, 3, 1, 2],
            [2, 1, 5, 4, 3],
            [3, 5, 1, 2, 4],
            [4, 3, 2, 5, 1],
            [1, 2, 4, 3, 5]].
