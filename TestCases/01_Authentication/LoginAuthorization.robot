*** Settings ***
Resource    ../../Keywords/loginFunction.robot

Test Teardown  Run Keywords
...  Close All Browsers

*** Variables ***


*** Test Cases ***
C1: Login with valid user and getting success logged-in
	[Tags]  regression_test    smoke_test    loginSuccess    
    Given Launch SwagLab Portal
    When User logged-in with username and password  ${user.validUser}  
    Then Found main page product

C2: Login with lock user and getting error while logged-in
    [Tags]  regression_test  
    Given Launch SwagLab Portal
    When User logged-in with username and password  ${user.lockUser}  
    Then Display error while logged-in    ${msgAuthen.error.userLock}

C3: Login with problem user success then getting main page with all same products
    [Tags]  regression_test    loginSuccess    
    Given Launch SwagLab Portal
    When User logged-in with username and password  ${user.problem_user}  
    Then Found main page product

C4: Login with performance user success
    [Tags]  regression_test    loginSuccess  
    Given Launch SwagLab Portal
    When User logged-in with username and password  ${user.perfUser}
    ${current_time}=    Evaluate    datetime.datetime.now().strftime('%H:%M:%S.%f')[:-3]
    ${success_time} =  Found main page product
    ${time_difference} =    DateTime.Subtract Time From Time    ${success_time}    ${current_time}

C5: Login with invalid user and getting failed
	[Tags]  regression_test    smoke_test    loginSuccess  
    Given Launch SwagLab Portal
    FOR  ${user}   IN    @{user.incorrectLogin}
        When Login with invalid user and password  ${user['userName']}  ${user['password']}
        Then Display error while logged-in    ${msgAuthen.error.incorrect}
    END

C6: Validate required field on logged-in page
    [Tags]  regression_test    loginSuccess    
    Given Launch SwagLab Portal
    FOR  ${user}   IN    @{user.requiredCheck}
        When Login with invalid user and password  ${user['userName']}  ${user['password']}
        Then Display error while logged-in    ${user['msg']}
    END

C7: Verify page logged-in must display field and button belong to design
    [Tags]  regression_test    loginSuccess  
    Given Launch SwagLab Portal
    Then Display value  ${LoginPage.Wording}
    And Page present field and button Login

C8: Verify getting main page shows difference product after logged-in success
    [Tags]  regression_test    smoke_test    loginSuccess   
    Given Launch SwagLab Portal
    When User logged-in with username and password  ${user.validUser}  
    Then Checking all topic is unique  ${LocatorHomePage.allProduct}  ${LocatorHomePage.singleProduct}

C9: Login with not exist user must shows error not matching on system
    [Tags]  regression_test    smoke_test    loginSuccess    
    Given Launch SwagLab Portal
    When User logged-in with username and password  ${user.notExistUser}  
    Then Display error while logged-in    ${msgAuthen.error.userNotExist}

C10: User can log out after login to porta
    [Tags]  regression_test    smoke_test    loginSuccess
    [Setup]  Launch SwagLab Portal
    Given User logged-in with username and password  ${user.validUser}
    When Found main page product
    And Logout success