*** Settings ***
Documentation     Logs into the Auth0 dashboard and creates a new tenant.
Library           RPA.Browser
Library           RPA.Robocloud.Items
Library           RPA.Robocloud.Secrets

*** Variables ***
${AUTH0_URL}         https://manage.auth0.com/
&{DICT}              au=1    eu=2    us=3

*** Keyword ***
Open Auth0 dashboard
    Open Available Browser    ${AUTH0_URL}
    Maximize Browser Window
    Wait Until Page Contains       Log In

*** Keyword ***
Login
    [Arguments]    ${username}     ${password}
    Input Text    name:email       ${username}
    Input Text    name:password    ${password}
    Click Button                   xpath://html/body/div/div/div[2]/form/div[2]/div/div/button
    Set Selenium Timeout           20 seconds
    Wait Until Page Contains       Dashboard

*** Keyword ***
Create tenant
    [Arguments]    ${tenant_name}       ${tenant_region}
    Click Element   name:chevron-down
    Wait Until Page Contains       Create tenant    
    Click Element   name:plus
    Wait Until Page Contains       New Tenant
    Input Text    name:name    ${tenant_name}

    Click Element       xpath://*[@id="dialog-description"]/fieldset/form/div/div[2]/div/div[2]/div[1]/span[${DICT}[${TENANT_REGION}]]/button  # Flag    
    Click Button        xpath://html/body/div[2]/div/div/div[3]/div/footer/div/span[1]/button  # Create
    
    Wait Until Page Does Not Contain       New Tenant

*** Keyword ***
Init Environment for API
    Load Work Item From Environment
    ${T_NAME}=    Get Work Item Variable    TENANT_NAME
    ${T_REGION}=    Get Work Item Variable    TENANT_REGION    
    Set Global Variable    ${TENANT_NAME}       ${T_NAME}        
    Set Global Variable    ${TENANT_REGION}     ${T_REGION}     

*** Keyword ***
Init Environment for Local Dev    
    Set Global Variable    ${TENANT_NAME}       %{TENANT_NAME}        
    Set Global Variable    ${TENANT_REGION}     %{TENANT_REGION}    

*** Tasks ***
Log into the Auth0 dashboard and create a new tenant
    Open Auth0 dashboard
    ${secrets}=   Get Secret  AUTH0        
    Login              ${secrets}[AUTH0_USERNAME]       ${secrets}[AUTH0_PASSWORD]
    
    Run Keyword And Ignore Error       Init Environment for API
    Run Keyword And Ignore Error       Init Environment for Local Dev    
    
    Create tenant      ${TENANT_NAME}           ${TENANT_REGION}
    [Teardown]    Close Browser
