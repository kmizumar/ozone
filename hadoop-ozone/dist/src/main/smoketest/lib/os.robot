# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

*** Settings ***
Library     OperatingSystem

*** Keywords ***
Execute
    [arguments]                     ${command}
    Run Keyword And Return          Execute and checkrc             ${command}                  0

Execute And Ignore Error
    [arguments]                     ${command}
    ${rc}                           ${output} =                 Run And Return Rc And Output           ${command}
    Log                             ${output}
    [return]                        ${output}

Execute and checkrc
    [arguments]                     ${command}                  ${expected_error_code}
    ${rc}                           ${output} =                 Run And Return Rc And Output           ${command}
    Log                             ${output}
    Should Be Equal As Integers     ${rc}                       ${expected_error_code}
    [return]                        ${output}

Compare files
    [arguments]                 ${file1}                   ${file2}
    ${checksumbefore} =         Execute                    md5sum ${file1} | awk '{print $1}'
    ${checksumafter} =          Execute                    md5sum ${file2} | awk '{print $1}'
                                Should Be Equal            ${checksumbefore}            ${checksumafter}

Create Random File
    ${postfix} =             Generate Random String  5  [NUMBERS]
    ${tmpfile} =             Set Variable   /tmp/tempfile-${postfix}
    File Should Not Exist    ${tmpfile}
    ${content} =             Set Variable   "Random string"
    Create File              ${tmpfile}    ${content}
    [Return]                 ${tmpfile}

List All Processes
    ${output} =    Execute    ps aux
    [return]    ${output}
