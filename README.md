# Currency

# 소개

송금 국가, 수취 국가 그리고 송금액을 사용자로부터 입력 받아, 환율을 계산하여 그 결과를 표현합니다

## 기능

- 수취 국가를 선택할 수 있습니다
    - 수취 국가에 따른 환율을 확인할 수 있습니다
    - 환율이 조회된 시간을 확인할 수 있습니다
- 송금액을 입력할 수 있습니다
    - 입력이 될 때마다 환율을 계산하여 이를 확인할 수 있습니다

## 제한

- 송금 국가는 `🇺🇸 미국, USD` 로 고정합니다
- 가능한 수취 국가는 `🇰🇷 한국, KRW` `🇯🇵 일본, JPY` `🇵🇭 필리핀, PHP` 총 세개의 국가로 제한합니다
- 송금액의 범위는 `0에서  10,000 (단위: USD)`로 제한합니다
- 환율과 수취 금액의 형식은 통화의 양식을 취하며, 소수점의 경우 최대 두자리까지 표현합니다

    `예) 113,004.98`

- 시간의 표현은 다음 양식을 따릅니다 `yyyy-MM-dd hh:mm`

# 구성

![Currency%201e572324a51d41af8fc66c7099d48382/Untitled.png](Currency%201e572324a51d41af8fc66c7099d48382/Untitled.png)

- 🖼 **CurrencyViewController**

    유저 인터페이스와 관련됩니다

- 👨🏽‍🍳 **CurrencyViewModel**

    View에서 사용할 수 있도록 데이터를 적절하게 가공합니다

    - **CurrencyCodes**

        통화 코드 정보를 가지고 있는 `Enum`입니다

        View에서 보여줄 정보를 가공할 때와 API 호출시 사용됩니다

    - **DateFormatter**

        네트워크 호출로부터 받아오는 Unix Timestamp를 적절한 형식으로 변환합니다

    - **NumberFormatter**

        네트워크 호출로부터 받아오는 환율 정보와 계산된 수취 금액을 적절한 형식으로 변환합니다

- 🌐 **CurrencyService**

    네트워크, API 호출을 담당합니다

- 💵 **Currency**

    앱에서 사용될 수 있는 환율과 관련된 정보입니다

## CurrencyViewModelDelegate

사용자 동작, 네트워크 호출 결과에 따른 동작을 정의합니다

`CurrencyViewModel`에서 `CurrencyViewController`를 `weak var delegate: CurrencyViewModelDelegate`로 소유합니다

```swift
protocol CurrencyViewModelDelegate {
        /// Receiver에게 수취 국가가 변경되었음을 알린다
    /// - Parameters:
    ///   - destination: 변경된 수취 국가의 통화 코드
    ///   - description: 변경된 수취 국가의 통화 코드가 포함된 표현
    func currencyViewModel(didChangeDestination destination: String, description: String)
    
    /// Receiver에게 이용 가능한 수취 국가의 목록이 변경되었음을 알린다
    ///
    /// ```
    ///  list["time"] // 2020-01-01 00:00
    ///  list["description"] // 1,130.05 KRW / USD
    /// ```
    ///
    /// - Parameter list: 이용 가능한 수취 국가 목록
    func currencyViewModel(didChangeCurrencyList list: [String:String])
    
    /// Receiver에게 API 호출이 성공하여, 그 결과를 이용할 수 있음을 알린다
    /// - Parameter currency: 환율 정보를 가지고 있는 딕셔너리
    func currencyViewModel(didReceiveCurrency currency: [String:String])
    
    /// Receiver에게 API 호출이 실패했음을 알린다
    /// - Parameter error: 표현 가능한 오류 문자열
    func currencyViewModel(didReceiveError error: String)
    
    /// Receiver에게 환율을 계산하여 그 결과를 이용할 수 있음을 알린다
    /// - Parameters:
    ///   - result: 표현 가능한 형태로 변환된 문자열
    ///   - isSuccessed: 계산 완료 여부를 나타내는 부울 값
    func currencyViewModel(didCalculate result: String, isSuccessed: Bool)}
}
```
