# Testing

```bash
~/dev-env/samples/testing> nosetests
F
======================================================================
FAIL: test_happy_path (integration_tests.SomeTestCase)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/vagrant/dev-env/samples/testing/integration_tests.py", line 33, in test_happy_path
    self.assertEqual(process.returncode, 1)
AssertionError: 0 != 1

----------------------------------------------------------------------
Ran 1 test in 0.004s

FAILED (failures=1)
```

```bash
~/dev-env/samples/testing> dev_env_nosetests.py
F
======================================================================
FAIL: test_happy_path (integration_tests.SomeTestCase)
----------------------------------------------------------------------
Traceback (most recent call last):
  File "/home/vagrant/dev-env/samples/testing/integration_tests.py", line 33, in test_happy_path
    self.assertEqual(process.returncode, 1)
AssertionError: ------------------------- >> begin stdout << -------------------------
"dave was here"

-------------------------- >> end stdout << --------------------------
0 != 1

----------------------------------------------------------------------
Ran 1 test in 0.004s

FAILED (failures=1)
~/dev-env/samples/testing>
```

## What Next

* take a look at [my other projects on github](https://github.com/simonsdave)
for examples of how ```dev-env``` is being used
* as you start to integrate ```dev-env``` into your projects
some feedback would be great - create [issues](../../../issues) and/or
send me an e-mail [simonsdave@gmail.com](mailto:simonsdave@gmail.com) - thanks in advance!
