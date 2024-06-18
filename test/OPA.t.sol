// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.19;

import {OPA} from "../src/OPA.sol";
import {Test} from "../lib/forge-std/src/Test.sol";

contract OPATest is Test {
    OPA internal opa;

    address z = 0x1C0Aa8cCD568d90d61659F060D1bFb1e6f855A20;

    function setUp() public payable {
        vm.createSelectFork(vm.rpcUrl("opti")); // Optimism EthL2 fork.
        opa = new OPA();
    }

    function testAlignment() public payable {
        vm.prank(z);
        opa.align{value: 0.001 ether}();
    }
}
