// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.19;

import "../Runtime/Executable/Executable.sol";

/**
 * @title DARC Dashboard
 * @author DARC Team
 * @notice The dashboard (a set of view functions) of the DARC machine state,
 * which is used to read the machine state, including machine state, voting state,
 * token information, plugin information, etc.
 */
contract Dashboard is Executable {
  
  /**
   * @notice The getter function of the machine state plugins
   */
  function getPluginInfo() public view returns (Plugin[] memory, Plugin[] memory) {
    return (currentMachineState.beforeOpPlugins, currentMachineState.afterOpPlugins);
  }

  /**
   * @notice Get the available token classes
   */
  function getNumberOfTokenClasses() public view returns (uint256) {
    uint256 i;
    for (i=0; i < currentMachineState.tokenList.length; i++) {
      if (!currentMachineState.tokenList[i].bIsInitialized) {
        break;
      }
    }
    return i;
  }

  /**
   * @notice Get the token class information
   * @param tokenClassIndex the index of the token class
   */
  function getTokenOwners(uint256 tokenClassIndex) public view returns (address[] memory) {
    return currentMachineState.tokenList[tokenClassIndex].ownerList;
  }

  /**
   * Get the current token information
   * @param tokenClassIndex the index of the token class 
   */
  function getTokenInfo(uint256 tokenClassIndex) public view returns (uint256 votingWeight, uint256 dividendWeight, string memory tokenInfo, uint256 totalSupply) {
    return (currentMachineState.tokenList[tokenClassIndex].votingWeight, currentMachineState.tokenList[tokenClassIndex].dividendWeight, currentMachineState.tokenList[tokenClassIndex].tokenInfo, currentMachineState.tokenList[tokenClassIndex].totalSupply);
  }

  /**
   * @notice Get the token class information
   * @param tokenClassIndex the index of the token class
   * @param tokenOwnerAddress the address of the token owner
   */
  function getTokenOwnerBalance(uint256 tokenClassIndex, address tokenOwnerAddress) public view returns (uint256) {
    return currentMachineState.tokenList[tokenClassIndex].tokenBalance[tokenOwnerAddress];
  }

  /**
   * @notice Get the member list keys
   */
  function getMemberList() public view returns (address[] memory) {
    return currentMachineState.memberList;
  }

  /**
   * @notice Get the member information
   * @param member the address of the member
   */
  function getMemberInfo(address member) public view returns (MemberInfo memory) {
    return currentMachineState.memberInfoMap[member];
  }

  /**
   * @notice Get the current dividend balance of the address
   */
  function getWithdrawableCashBalance(address member) public view returns (uint256) {
    return currentMachineState.withdrawableCashMap[member];
  }

  /**
   * @notice Get the current list of the addresses that can withdraw the dividend
   */
  function getWithdrawableCashOwnerList() public view returns (address[] memory) {
    return currentMachineState.withdrawableCashOwnerList;
  }
 
  /**
   * @notice Get the current dividend balance of the address
   * @param member the address of the member
   */
  function getWithdrawableDividendBalance(address member) public view returns (uint256) {
    return currentMachineState.withdrawableDividendMap[member];
  }

  /**
   * @notice Get the current list of the addresses that can withdraw the dividend
   */
  function getWithdrawableDividendOwnerList() public view returns (address[] memory) {
    return currentMachineState.withdrawableDividendOwnerList;
  }

  function getMyInfo() public view returns (address) {
    return msg.sender;
  }

  /**
   * The getter function of total voting weight for a token class
   * @param tokenClassIndex The index of the token class
   */
  function getSumVotingWeightByTokenClass(uint256 tokenClassIndex) public view returns (uint256) {
    return sumVotingWeightForTokenClass(false, tokenClassIndex);
  }

  /**
   * The getter function of total dividend weight for a token class
   * @param tokenClassIndex The index of the token class
   */
  function getSumDividendWeightByTokenClass(uint256 tokenClassIndex) public view returns (uint256) {
    return sumDividendWeightForTokenClass(false, tokenClassIndex);
  }

  /**
   * Get the current dividend per unit
   */
  function getCurrentDividendPerUnit() public view returns (uint256) {
    return currentDividendPerUnit(false);
  }

  /**
   * Get all logs of DARC
   */
  function getDARClogs() public view returns (string[] memory) {
    return DARClogs;
  }

  /**
   * Get all voting items
   */
  function getVotingItemsByIndex(uint256 idx) public view returns (VotingItem memory) {
    return votingItems[idx];
  }

  /**
   * Get the latest voting item index
   */
  function getLatestVotingItemIndex() public view returns (uint256) {
    return latestVotingItemIndex;
  }

  /**
   * Get the global operation log
   */
  function getGlobalOperationLog() public view returns (OperationLog memory) {
    return currentMachineState.globalOperationLog;
  }

  /**
   * Get the operation log of the address
   */
  function getOperationLogByAddress(address addr) public view returns (OperationLog memory) {
    return currentMachineState.operationLogMap[addr];
  }
}
