(* Test/exercise version: "1.0.0" *)

open Core
open OUnit2
open Change

let printer = Option.value_map ~default:"None" ~f:(List.to_string ~f:Int.to_string)
let ae exp got _test_ctxt = assert_equal ~printer exp got

let tests = [
   "single coin change" >::
      ae (Some [25]) 
         (make_change ~target:25 ~coins:[1; 5; 10; 25; 100]);
   "multiple coin change" >::
      ae (Some [5; 10]) 
         (make_change ~target:15 ~coins:[1; 5; 10; 25; 100]);
   "change with Lilliputian Coins" >::
      ae (Some [4; 4; 15]) 
         (make_change ~target:23 ~coins:[1; 4; 15; 20; 50]);
   "change with Lower Elbonia Coins" >::
      ae (Some [21; 21; 21]) 
         (make_change ~target:63 ~coins:[1; 5; 10; 21; 25]);
   "large target values" >::
      ae (Some [2; 2; 5; 20; 20; 50; 100; 100; 100; 100; 100; 100; 100; 100; 100]) 
         (make_change ~target:999 ~coins:[1; 2; 5; 10; 20; 50; 100]);
   "possible change without unit coins available" >::
      ae (Some [2; 2; 2; 5; 10]) 
         (make_change ~target:21 ~coins:[2; 5; 10; 20; 50]);
   "no coins make 0 change" >::
      ae (Some []) 
         (make_change ~target:0 ~coins:[1; 5; 10; 21; 25]);
   "error testing for change smaller than the smallest of coins" >::
      ae None 
         (make_change ~target:3 ~coins:[5; 10]);
   "error if no combination can add up to target" >::
      ae None 
         (make_change ~target:94 ~coins:[5; 10]);
   "cannot find negative change values" >::
      ae None 
         (make_change ~target:(-5) ~coins:[1; 2; 5]);
]

let () =
  run_test_tt_main ("change tests" >::: tests)