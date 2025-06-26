use aiken/collection/list
use cardano/address.{Credential}
use cardano/assets.{Lovelace}
use cardano/certificate.{
  Certificate, DelegateBlockProduction, DelegateBoth, DelegateCredential,
  DelegateRepresentative, DelegateVote, RegisterCredential,
  RegisterDelegateRepresentative, StakePoolId, UnregisterCredential,
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
