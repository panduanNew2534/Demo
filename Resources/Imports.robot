*** Settings ***
Library      SeleniumLibrary  timeout=10  implicit_wait=10    #timeout if perform keyword more than 10s then timeout, implicit_wait if no element found then wait only 10s to kick out
Library      DateTime
Library      OperatingSystem
Library      String
Library      random
Library      Collections
Library      JSONLibrary
Variables    testdatas/${env}/testdatas.yaml
Variables    testdatas/common.yaml
Variables    configs/${env}/env_config.yaml
Variables    locators/selector.yaml

*** Variables ***
&{all_application_info}
&{all_manage_account_info}
${env}    qa
# ${env}    dev