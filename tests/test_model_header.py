import json
import os
from unittest import TestCase
from unittest.mock import patch
import stand

class ModelHeader(TestCase):
    def test_model_override_is_in_request_header_without_changing_profile(self):
        class Response:
            def __enter__(self):return self
            def __exit__(self,*args):pass
            def read(self):return b'{}'
        captured=[]
        def open_request(req,timeout):
            captured.append(req)
            return Response()
        with patch.dict(os.environ,{'EVAL_MODEL':'anthropic/claude-haiku-5.5'}),patch.object(stand._opener,'open',side_effect=open_request):
            stand._call('GET','/health')
        settings=json.loads(captured[0].get_header('X-stand-settings'))
        self.assertEqual(settings,{'model':'anthropic/claude-haiku-5.5'})
