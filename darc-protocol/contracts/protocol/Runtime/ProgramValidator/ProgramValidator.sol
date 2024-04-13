// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import "../../Program.sol";

/**
 * @notice The library to validate the program and each operations in the program
 * Since the struct Program does not contain any nested struct, we can 
 * use functions in this library, instead of functions in the contract.
 * 
 * This library is used to validate the basic properties of the program,
 * such as the length of the program, the length of the parameters of
 * each operation, the length of the parameter array, etc.
 * 
 * For more specific validation via the plugins, we need to use the
 * contract Runtime.
 *  */ 
library ProgramValidator{
  function validate(Program memory currentProgram) internal pure returns (bool) {
    for (uint256 i = 0; i < currentProgram.operations.length; i++) {

      // check if the operation is valid. UNDEFINED is not a valid operation
      if (currentProgram.operations[i].opcode == EnumOpcode.UNDEFINED) {
        return false;
      }

      // check if operation is "BATCH_MINT_TOKENS", and validate the operation
      if (currentProgram.operations[i].opcode == EnumOpcode.BATCH_MINT_TOKENS) {
        //if (!ValidateBatchMintTokens.validate__BATCH_MINT_TOKENS(currentProgram.operations[i])) {
        //  return false;
        //}
      }

      // todo: add more validation for other operations
    }

    return true;
  }

  /**
   * Returns true if the program is a valid vote program
   * 1. There is only one operation in the program
   * 2. The operation is a vote operation
   * @param currentProgram The program to be validated
   */
  function validateVoteProgram(Program memory currentProgram) internal pure returns (bool) {
    //1. check if the program is empty
    if (currentProgram.operations.length != 1) { return false; }
    return validate_ID_32_VOTE(currentProgram.operations[0]);
  }

  /**
   * Returns true if the program is a valid execute pending program
   * 1. There is only one operation in the program
   * 2. The operation is a execute pending operation: ExecutePendingProgram
   * @param currentProgram The program to be validated
   */
  function validateExecutePendingProgram(Program memory currentProgram) internal pure returns (bool) {
    //1. check if the program is empty
    if (currentProgram.operations.length != 1) { return false; }
    return validate_ID_33_EXECUTE_PENDING_PROGRAM(currentProgram.operations[0]);
  }


  //----------------- validate each operation -----------------

  function validate_ID_32_VOTE(Operation memory op) internal pure returns (bool) {
    if (op.opcode != EnumOpcode.VOTE) { return false; }
    if (op.param.UINT256_2DARRAY.length != 0) { return false; }
    if (op.param.ADDRESS_2DARRAY.length != 0) { return false; }
    if (op.param.STRING_ARRAY.length != 0) { return false; }
    return true;
  }

  function validate_ID_33_EXECUTE_PENDING_PROGRAM(Operation memory op) internal pure returns (bool) {
    if (op.opcode != EnumOpcode.EXECUTE_PENDING_PROGRAM) { return false; }
    if (op.param.UINT256_2DARRAY.length != 0) { return false; }
    if (op.param.ADDRESS_2DARRAY.length != 0) { return false; }
    if (op.param.STRING_ARRAY.length != 0) { return false; }
    return true;
  }


}