# Parameters.xml Validation

A task to validate the [Parameters.xml](https://docs.microsoft.com/en-us/aspnet/web-forms/overview/deployment/web-deployment-in-the-enterprise/configuring-parameters-for-web-package-deployment) file(s) match the references app.config, web.config, or unity.config

## Validate Parameters

This task will find any parameters.xml files under the specified path, import them and compare each parameter entry in them against the relevant config file in the same directory. It'll check the XPath for each entry is a valid XPath query for the config file and fail the test if it is not.

It takes the following inputs:

**Path**: The top level folder to look under. The task will recurse through all of the folders under it looking for files called parameters.xml
**Fail if there are test failures**: Check box to fail the task if any of the tests fail.
**Test run title**: Test results are published under this title. By default the task will use "ValidateParameters.Xml - <Build_DefinitionName>" if no value is provided for this.
