# MiniAMM

[foundry](https://getfoundry.sh/forge/overview/)를 설치하고 forge 워크스페이스를 초기화하세요.

[faucet](https://faucet.flare.network/coston2)에 가서 EVM 지갑 주소를 입력하여 C2FLR 테스트넷 토큰을 받으세요. 이 지갑을 사용하여 컨트랙트를 배포하세요.

## 요구사항

`MiniAMM.sol`은 사용자에게 두 가지 기능을 제공합니다:

1. 유동성 추가: 사용자가 동시에 두 개의 토큰을 공급합니다. 본질적으로 이 함수는 토큰 쌍을 컨트랙트로 전송하여 $k$를 증가시킵니다. 그러나 $x$와 $y$의 비율은 일정해야 하며, 유동성이 처음 공급되는 경우를 제외하고는 그 비율이 유지되어야 합니다.
2. 스왑: 사용자는 $k$를 일정하게 유지하면서 $x$ 양의 토큰을 $y$ 양의 토큰으로 스왑할 수 있습니다. 본질적으로 이는 $x$ 양의 토큰을 컨트랙트로 전송하고, $k$를 일정하게 유지하면서 사용자에게 $y$ 양의 토큰을 전송합니다.

MiniAMM을 테스트할 수 있으려면 두 개의 서로 다른 모의 ERC-20 토큰을 배포해야 합니다:

1. `MockERC20.sol`의 완전한 MockERC20 컨트랙트를 완성하세요. `freeMintTo`는 `to`에게 `amount` 토큰을 민팅해야 합니다. `freeMintToSender`는 `msg.sender`에게 `amount` 토큰을 민팅합니다. 이 함수들은 누구나 호출할 수 있어야 하므로 민팅이 모든 사람에게 가능해야 합니다.

`forge test`를 실행하여 컨트랙트가 올바르게 작동하는지 테스트할 수 있습니다. **목표는 컨트랙트에 답을 하드코딩하지 않고 모든 테스트를 통과시키는 것입니다.**

그 후, [Flare Coston2 Testnet](https://coston2.testnet.flarescan.com/)에 선택한 임의의 이름과 심볼을 가진 두 개의 서로 다른 `MockERC20` 컨트랙트와 `MiniAMM` 컨트랙트를 **배포하고 검증**하세요. **검증**이란 컨트랙트 코드가 블록체인 탐색기에서 보이게 된다는 의미입니다. 배포자 계정에 자금을 제공하기 위해 [faucet](https://faucet.flare.network/coston2)을 사용해야 합니다.

`MiniAMM` 컨트랙트는 해당 두 `MockERC20` 컨트랙트 주소를 각각 `tokenX`와 `tokenY`로 받아야 합니다.

### 제출물

모든 작업을 완료하면 다음이 남게 됩니다:

- 완전한 `MiniAMM.sol` 구현
- 완전한 `MockERC20.sol` 구현
- 완전한 `MiniAMM.s.sol` 구현
- https://coston2.testnet.flarescan.com/에 배포된 `MiniAMM`과 두 개의 `MockERC20` 컨트랙트의 배포 주소
- `forge test`로 통과한 `test` 폴더의 모든 테스트
