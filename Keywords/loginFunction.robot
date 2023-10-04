*** Settings ***
Resource    ../Resources/Imports.robot
Resource    ./common/common.robot

*** Variables ***


*** Keywords ***
User logged-in with username and password
    [Arguments]  ${userSet}
    Wait Until Element Is Visible  ${LocatorLoginPage.xpathTopic}
    SeleniumLibrary.Input Text  ${LocatorLoginPage.username}  ${userSet.userName}
    SeleniumLibrary.Input Text  ${LocatorLoginPage.password}  ${userSet.password}
    SeleniumLibrary.Click Button  ${LocatorLoginPage.btnLogin}

Found main page product
    @{lstSRC} =  BuiltIn.Create List
    SeleniumLibrary.Wait Until Element Contains  ${LocatorHomePage.xpathTopic}  ${HomePage.topic}
    ${login_time} =    Evaluate    datetime.datetime.now().strftime('%H:%M:%S.%f')[:-3]
    SeleniumLibrary.Wait Until Element Contains  ${LocatorHomePage.xpathProductTopic}  ${HomePage.product}
    SeleniumLibrary.Location Should Contain  ${endpoint.homepage}  message='endpoint does not matching with expected'
    ${element_count} =    Get Element Count    //a[img]
    FOR  ${i}   IN RANGE    0    ${element_count-1}
        ${src_value} =    Get Element Attribute    xpath=//*[@id='item_${i}_img_link']/img    src
        List Should Not Contain Value    ${lstSRC}    ${src_value}    message=${src_value} is duplicated
        Append To List    ${lstSRC}    ${src_value}
    END
    # Log  ${lstSRC}
    [Return]  ${login_time}

Found detail product page
    [Arguments]
    @{src_values} =  BuiltIn.Create List
    SeleniumLibrary.Wait Until Element Contains  ${LocatorHomePage.xpathTopic}  ${HomePage.topic}
    SeleniumLibrary.Wait Until Element Contains  ${LocatorHomePage.xpathProductTopic}  ${HomePage.product}
    SeleniumLibrary.Location Should Contain  ${endpoint.homepage}  message='endpoint does not matching with expected'

Display error while logged-in
    [Arguments]  ${errorMsg}
    SeleniumLibrary.Wait Until Element Contains  ${LocatorLoginPage.errormsg}  ${errorMsg}

Login with invalid user and password
    [Arguments]  ${user}   ${password}
    Wait Until Element Is Visible  ${LocatorLoginPage.xpathTopic}
    Reload Page
    SeleniumLibrary.Input Text  ${LocatorLoginPage.username}  ${user}
    SeleniumLibrary.Input Text  ${LocatorLoginPage.password}  ${password}
    SeleniumLibrary.Click Button  ${LocatorLoginPage.btnLogin}

Page present field and button ${btnName}
    SeleniumLibrary.Element Should Be Enabled  ${LocatorLoginPage.username}
    SeleniumLibrary.Element Should Be Enabled  ${LocatorLoginPage.password}
    SeleniumLibrary.Element Should Be Enabled  ${LocatorLoginPage.btnLogin}
    ${value} =    Get Element Attribute    ${LocatorLoginPage.btnLogin}    value
    BuiltIn.Should Be True  '${value}'=='${btnName}'

Display value
    [Arguments]  ${value}
    FOR  ${i}  IN  @{value}
        Log    ${i}
        SeleniumLibrary.Page Should Contain  ${i}
    END

Checking all topic is unique
    [Arguments]    ${element}    ${singleEL}    ${attr}=NONE
    @{lstSRC} =  BuiltIn.Create List
    ${element_count} =    Get Element Count    ${element}
    FOR  ${i}   IN RANGE    0    ${element_count-1}
        ${i_string} =  BuiltIn.Convert To String  ${i}
        ${newEl} =    Replace String    ${singleEL}    {{id}}    ${i_string}
        ${src_value} =    Get Text    ${newEl}
        Log   ${newEl}
        List Should Not Contain Value    ${lstSRC}    ${src_value}    message=${src_value} is duplicated
        Append To List    ${lstSRC}    ${src_value}
    END
    Log  ${lstSRC}

Logout success
    SeleniumLibrary.Click Element  ${HambergerMenu.hamberger}
    SeleniumLibrary.Wait Until Element Is Visible  ${HambergerMenu.logoutbtn}
    SeleniumLibrary.Click Element  ${HambergerMenu.logoutbtn}
    