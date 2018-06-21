pragma solidity 0.4.23;

import "./Listing.sol";

contract FractionalListing is Listing {

  /*
   * Events
   */

  event ListingPurchased(Purchase _purchaseContract);

  /*
  * Storage
  */

  struct Version {
      uint timestamp;
      bytes32 ipfsHash;
  }

  Purchase[] public purchases;
  Version[] public versions;


  constructor (
    address _owner,
    bytes32 _ipfsHash
  )
  public
  {
    owner = _owner;
    listingRegistry = msg.sender; // ListingRegistry(msg.sender);
    versions.push(Version(now, _ipfsHash));
    created = now;
    expiration = created + 60 days;
    needsSellerApproval = true;
  }

  /*
    * Public functions
  */

  function isApproved(Purchase _purchase)
    public
    view
    returns (bool)
  {
    return false;
  }

  function ipfsHash()
    public
    constant
    returns (bytes32)
  {
    return versions[currentVersion()].ipfsHash;
  }

  function currentVersion()
    public
    constant
    returns (uint)
  {
    return versions.length - 1;
  }

  function data(uint _version)
    public
    constant
    returns (uint timestamp, bytes32 _ipfsHash)
  {
    return (versions[_version].timestamp, versions[_version].ipfsHash);
  }

  function update(uint _currentVersion, bytes32 _ipfsHash)
    public
    isSeller
  {
    if (_currentVersion == currentVersion()) {
      versions.push(Version(now, _ipfsHash));
      emit ListingChange();
    }
  }

}