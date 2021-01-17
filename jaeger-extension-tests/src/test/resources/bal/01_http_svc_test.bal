// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;
import ballerina/http;
import ballerina/observe; import ballerinax/jaeger as _;   // TODO: Remove extension module imports

service /test on new http:Listener(9091) {
    resource function get sum(http:Caller caller, http:Request req) {
        ObservableAdderClass adder = new ObservableAdder(20, 33);
        var sum = adder.getSum();

        http:Response resp = new;
        resp.setTextPayload(<@untainted> "Sum: " + sum.toString());
        checkpanic caller->respond(resp);
    }
}

type ObservableAdderClass object {
    @observe:Observable
    function getSum() returns int;
};

class ObservableAdder {
    private int firstNumber;
    private int secondNumber;

    function init(int a, int b) {
        self.firstNumber = a;
        self.secondNumber = b;
    }

    function getSum() returns int {
        return self.firstNumber + self.secondNumber;
    }
}

public function main() {
    io:println("Starting Jaeger Resources");
}
