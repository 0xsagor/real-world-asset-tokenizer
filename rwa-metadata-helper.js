const { ethers } = require("ethers");

/**
 * Encodes RWA metadata for deployment or updates.
 */
function generateLegalHash(documentBuffer) {
    const hash = ethers.keccak256(documentBuffer);
    console.log(`Document Fingerprint (SHA3): ${hash}`);
    return hash;
}

module.exports = { generateLegalHash };
