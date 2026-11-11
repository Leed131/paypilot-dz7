import json
from pathlib import Path
import sys
import unittest
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
import runner

META={'budget_scope':'per_run','budget':{'identical_tool_calls_max':1}}
def tree(*calls):
    return {'name':'agent.request','children':[{'name':'tool.'+name,'attributes':{'tool.arguments':args}} for name,args in calls]}
def run(*steps):
    return {'usage':{'input_tokens':0,'output_tokens':0},'trace':steps[-1], 'turns':[{'trace':t} for t in steps]}

class D14Budget(unittest.TestCase):
    def test_repeat_in_first_step_is_detected_even_when_last_step_is_clean(self):
        verdict=runner._budget(META,[run(tree(('get_transactions',{'account_id':'A'}),('get_transactions',{'account_id':'A'})),tree())])
        self.assertFalse(verdict.passed)
        self.assertEqual(verdict.level,1)

    def test_different_arguments_are_distinct_calls(self):
        self.assertTrue(runner._budget(META,[run(tree(('get_transactions',{'account_id':'A'}),('get_transactions',{'account_id':'B'})))]).passed)

    def test_same_call_in_different_steps_is_allowed(self):
        step=tree(('get_transactions',{'account_id':'A'}))
        self.assertTrue(runner._budget(META,[run(step,step)]).passed)

    def test_json_key_order_and_serialization_do_not_hide_repetition(self):
        step=tree(('get_transactions',{'a':1,'b':2}),('get_transactions','{"b":2,"a":1}'))
        self.assertFalse(runner._budget(META,[run(step)]).passed)

    def test_missing_trace_is_not_a_pass(self):
        self.assertFalse(runner._budget(META,[run(None)]).passed)

    def test_missing_arguments_is_not_a_pass(self):
        self.assertFalse(runner._budget(META,[run(tree(('get_transactions',None)))]).passed)

    def test_token_budget_does_not_change_with_call_count_fix(self):
        result=run(tree());result['usage']={'input_tokens':100,'output_tokens':20}
        self.assertTrue(runner._budget({'budget_scope':'per_run','budget':{'tokens_total':120}},[result]).passed)
        self.assertFalse(runner._budget({'budget_scope':'per_run','budget':{'tokens_total':119}},[result]).passed)

if __name__=='__main__':unittest.main()
