use aiken/collection/list
use cardano/address.{Credential, Script}
use cardano/assets.{Lovelace}
use cardano/certificate.{
  Certificate, DelegateBlockProduction, DelegateBoth, DelegateCredential,
  DelegateRepresentative, DelegateVote, RegisterCredential,
  RegisterDelegateRepresentative, Registered, StakePoolId, UnregisterCredential,
  UnregisterDelegateRepresentative,
}

/// Check if a certain stake registration certificate exists in certificates.
/// ```aiken
/// let is_stake_registerd = register_stake_certificate(certificates, stake_credential)
/// ```
pub fn register_stake_certificate(
  certificates: List<Certificate>,
  credential: Credential,
) {
  list.has(certificates, RegisterCredential { credential, deposit: Never })
}

test register_stake_certificate_found() {
  let certificates =
    [
      RegisterCredential { credential: Script(""), deposit: Never },
      UnregisterCredential { credential: Script(""), refund: Never },
    ]

  register_stake_certificate(certificates, Script("")) == True
}

test register_stake_certificate_not_found() {
  let certificates =
    [
      RegisterCredential { credential: Script("Not Found"), deposit: Never },
      UnregisterCredential { credential: Script("Not Found"), refund: Never },
    ]

  register_stake_certificate(certificates, Script("")) == False
}

/// Check if a certain stake unregistration certificate exists in certificates.
/// ```aiken
/// let is_stake_unregisterd = unregister_stake_certificate(certificates, stake_credential)
/// ```
pub fn unregister_stake_certificate(
  certificates: List<Certificate>,
  credential: Credential,
) {
  list.has(certificates, UnregisterCredential { credential, refund: Never })
}

test unregister_stake_certificate_found() {
  let certificates =
    [
      RegisterCredential { credential: Script(""), deposit: Never },
      UnregisterCredential { credential: Script(""), refund: Never },
    ]

  unregister_stake_certificate(certificates, Script("")) == True
}

test unregister_stake_certificate_not_found() {
  let certificates =
    [
      RegisterCredential { credential: Script("Not Found"), deposit: Never },
      UnregisterCredential { credential: Script("Not Found"), refund: Never },
    ]

  unregister_stake_certificate(certificates, Script("")) == False
}

/// Check if a certain drep registration with specified deposit certificate exists in certificates.
/// ```aiken
/// let is_drep_registerd = register_drep_certificate(certificates, stake_credential, deposit)
/// ```
pub fn register_drep_certificate(
  certificates: List<Certificate>,
  credential: Credential,
  deposit: Lovelace,
) {
  list.has(
    certificates,
    RegisterDelegateRepresentative {
      delegate_representative: credential,
      deposit,
    },
  )
}

test register_drep_certificate_found() {
  let certificates =
    [
      RegisterDelegateRepresentative {
        delegate_representative: Script(""),
        deposit: 10,
      },
      UnregisterDelegateRepresentative {
        delegate_representative: Script(""),
        refund: 10,
      },
    ]

  register_drep_certificate(certificates, Script(""), 10) == True
}

test register_drep_certificate_not_found_with_diff_cred() {
  let certificates =
    [
      RegisterDelegateRepresentative {
        delegate_representative: Script("Not Found"),
        deposit: 10,
      },
      UnregisterDelegateRepresentative {
        delegate_representative: Script("Not Found"),
        refund: 10,
      },
    ]

  register_drep_certificate(certificates, Script(""), 10) == False
}

test register_drep_certificate_not_found_with_diff_deposit() {
  let certificates =
    [
      RegisterDelegateRepresentative {
        delegate_representative: Script("Not Found"),
        deposit: 0,
      },
      UnregisterDelegateRepresentative {
        delegate_representative: Script("Not Found"),
        refund: 0,
      },
    ]

  register_drep_certificate(certificates, Script(""), 10) == False
}

/// Check if a certain drep unregistration with specified refund certificate exists in certificates.
/// ```aiken
/// let is_drep_unregisterd = unregister_drep_certificate(certificates, stake_credential, refund)
/// ```
pub fn unregister_drep_certificate(
  certificates: List<Certificate>,
  credential: Credential,
  refund: Lovelace,
) {
  list.has(
    certificates,
    UnregisterDelegateRepresentative {
      delegate_representative: credential,
      refund,
    },
  )
}

test unregister_drep_certificate_found() {
  let certificates =
    [
      RegisterDelegateRepresentative {
        delegate_representative: Script(""),
        deposit: 10,
      },
      UnregisterDelegateRepresentative {
        delegate_representative: Script(""),
        refund: 10,
      },
    ]

  unregister_drep_certificate(certificates, Script(""), 10) == True
}

test unregister_drep_certificate_not_found_with_diff_cred() {
  let certificates =
    [
      RegisterDelegateRepresentative {
        delegate_representative: Script("Not Found"),
        deposit: 10,
      },
      UnregisterDelegateRepresentative {
        delegate_representative: Script("Not Found"),
        refund: 10,
      },
    ]

  unregister_drep_certificate(certificates, Script(""), 10) == False
}

test unregister_drep_certificate_not_found_with_diff_refund() {
  let certificates =
    [
      RegisterDelegateRepresentative {
        delegate_representative: Script("Not Found"),
        deposit: 0,
      },
      UnregisterDelegateRepresentative {
        delegate_representative: Script("Not Found"),
        refund: 0,
      },
    ]

  unregister_drep_certificate(certificates, Script(""), 10) == False
}

/// Check if a certain stake delegation to a specificed pool certificate exists in certificates.
/// ```aiken
/// let is_stake_delegated = delegate_stake_certificate(certificates, stake_credential, stake_pool)
/// ```
pub fn delegate_stake_certificate(
  certificates: List<Certificate>,
  credential: Credential,
  stake_pool: StakePoolId,
) {
  list.has(
    certificates,
    DelegateCredential {
      credential,
      delegate: DelegateBlockProduction { stake_pool },
    },
  )
}

test delegate_stake_certificate_found() {
  let certificates =
    [
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateBlockProduction { stake_pool: "" },
      },
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateVote {
          delegate_representative: Registered(Script("")),
        },
      },
    ]

  delegate_stake_certificate(certificates, Script(""), "") == True
}

test delegate_stake_certificate_not_found_with_diff_cred() {
  let certificates =
    [
      DelegateCredential {
        credential: Script("Not Found"),
        delegate: DelegateBlockProduction { stake_pool: "" },
      },
      DelegateCredential {
        credential: Script("Not Found"),
        delegate: DelegateVote {
          delegate_representative: Registered(Script("")),
        },
      },
    ]

  delegate_stake_certificate(certificates, Script(""), "") == False
}

test delegate_stake_certificate_not_found_with_diff_pool() {
  let certificates =
    [
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateBlockProduction { stake_pool: "Not Found" },
      },
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateVote {
          delegate_representative: Registered(Script("")),
        },
      },
    ]

  delegate_stake_certificate(certificates, Script(""), "") == False
}

/// Check if a certain voting power delegation to a specificed drep certificate exists in certificates.
/// ```aiken
/// let is_vote_delegated = delegate_vote_certificate(certificates, stake_credential, delegate_representative)
/// ```
pub fn delegate_vote_certificate(
  certificates: List<Certificate>,
  credential: Credential,
  delegate_representative: DelegateRepresentative,
) {
  list.has(
    certificates,
    DelegateCredential {
      credential,
      delegate: DelegateVote { delegate_representative },
    },
  )
}

test delegate_vote_certificate_found() {
  let certificates =
    [
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateBlockProduction { stake_pool: "" },
      },
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateVote {
          delegate_representative: Registered(Script("")),
        },
      },
    ]

  delegate_vote_certificate(certificates, Script(""), Registered(Script(""))) == True
}

test delegate_vote_certificate_not_found_with_diff_cred() {
  let certificates =
    [
      DelegateCredential {
        credential: Script("Not Found"),
        delegate: DelegateBlockProduction { stake_pool: "" },
      },
      DelegateCredential {
        credential: Script("Not Found"),
        delegate: DelegateVote {
          delegate_representative: Registered(Script("")),
        },
      },
    ]

  delegate_vote_certificate(certificates, Script(""), Registered(Script(""))) == False
}

test delegate_vote_certificate_not_found_with_diff_drep() {
  let certificates =
    [
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateBlockProduction { stake_pool: "Not Found" },
      },
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateVote {
          delegate_representative: Registered(Script("Not Found")),
        },
      },
    ]

  delegate_vote_certificate(certificates, Script(""), Registered(Script(""))) == False
}

/// Check if a certain delegation to a specificed pool and drep certificate exists in certificates.
/// ```aiken
/// let is_stake_and_vote_delegated = delegate_stake_and_vote_certificate(certificates, stake_credential, stake_pool, delegate_representative)
/// ```
pub fn delegate_stake_and_vote_certificate(
  certificates: List<Certificate>,
  credential: Credential,
  stake_pool: StakePoolId,
  delegate_representative: DelegateRepresentative,
) {
  list.has(
    certificates,
    DelegateCredential {
      credential,
      delegate: DelegateBoth { stake_pool, delegate_representative },
    },
  )
}

test delegate_stake_and_vote_certificate_found() {
  let certificates =
    [
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateBlockProduction { stake_pool: "" },
      },
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateVote {
          delegate_representative: Registered(Script("")),
        },
      },
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateBoth {
          stake_pool: "",
          delegate_representative: Registered(Script("")),
        },
      },
    ]

  delegate_stake_and_vote_certificate(
    certificates,
    Script(""),
    "",
    Registered(Script("")),
  ) == True
}

test delegate_stake_and_vote_certificate_not_found_with_diff_cred() {
  let certificates =
    [
      DelegateCredential {
        credential: Script("Not Found"),
        delegate: DelegateBlockProduction { stake_pool: "" },
      },
      DelegateCredential {
        credential: Script("Not Found"),
        delegate: DelegateVote {
          delegate_representative: Registered(Script("")),
        },
      },
      DelegateCredential {
        credential: Script("Not Found"),
        delegate: DelegateBoth {
          stake_pool: "",
          delegate_representative: Registered(Script("")),
        },
      },
    ]

  delegate_stake_and_vote_certificate(
    certificates,
    Script(""),
    "",
    Registered(Script("")),
  ) == False
}

test delegate_stake_and_vote_certificate_not_found_with_diff_drep() {
  let certificates =
    [
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateBlockProduction { stake_pool: "" },
      },
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateVote {
          delegate_representative: Registered(Script("")),
        },
      },
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateBoth {
          stake_pool: "",
          delegate_representative: Registered(Script("Not Found")),
        },
      },
    ]

  delegate_stake_and_vote_certificate(
    certificates,
    Script(""),
    "",
    Registered(Script("")),
  ) == False
}

test delegate_stake_and_vote_certificate_not_found_with_diff_pool() {
  let certificates =
    [
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateBlockProduction { stake_pool: "" },
      },
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateVote {
          delegate_representative: Registered(Script("")),
        },
      },
      DelegateCredential {
        credential: Script(""),
        delegate: DelegateBoth {
          stake_pool: "Not Found",
          delegate_representative: Registered(Script("")),
        },
      },
    ]

  delegate_stake_and_vote_certificate(
    certificates,
    Script(""),
    "",
    Registered(Script("")),
  ) == False
}
