
module Distribution.AutoUpdate.VerifySignatures (verifyUpdate, verifyUpdateIO) where


import Data.ByteString.Lazy as BS

import Crypto.Types.PubKey.RSA
import Codec.Crypto.RSA

import Control.Monad.Trans.Error

import Utils


-- | Verifies the contents of a given file to a signature (given by file).
-- Raises an error (in the error monad), if the signature is not correct.
verifyUpdate :: FilePath -> FilePath -> ErrorT String IO ()
verifyUpdate updateFile signatureFile = do
    update <- io $ BS.readFile updateFile
    signature <- io $ BS.readFile signatureFile
    case verify joyridelabsPublicKey update signature of
        True -> return ()
        False -> throwError $ unlines (
            "Cannot verify the authenticity" :
            "of the downloaded package." :
            [])

-- | io version
verifyUpdateIO :: FilePath -> FilePath -> IO ()
verifyUpdateIO updateFile signatureFile = do
    result <- runErrorT $ verifyUpdate updateFile signatureFile
    case result of
        Left errors -> error ("signature is incorrect:\n" ++ errors)
        Right () -> return ()

joyridelabsPublicKey :: PublicKey
joyridelabsPublicKey = PublicKey {public_size = 512, public_n = 739253854112858456209372347213527984192460228033185069076782989845742968486927276122985885616892283595676079813615763086411083395121437411549747008676391664472049274908128179348313240016207399729776187534856616342737221707548322126776035652251085020699307864313206804855818535542648151208029059179591670000406984907400555261278942649389577760003075072719512554177858363484243213830343451004710376646714404634546889326280099859100195740707325374680475919572203963043204034579292796194880284237292031941435231512796511907184876191380993262200040448141012615244208599391625208353712489756997085549656493604498528099610231031527991731040028231845600174758847725285988439228534831961968426614686534846799256847938454769301046728109743169420448540412043657409565058055528896390094954133391338491323121280341066944843742206629634983409197347648752978880230079918223861011269874083954129795276997656099146384792379470231905954085250694751024779099707387624948750640848809621875100086633785984983486181802421525288123352179898166582484427303385111228571372318616171348394513424883158162937275662788697077920746562300570479011651136622776649398750786593858962069899964210137796649806968940217772460179503290493728626978556121451060715933443833, public_e = 65537}

