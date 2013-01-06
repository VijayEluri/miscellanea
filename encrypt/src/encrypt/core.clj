(ns encrypt.core
  (:require [clojure.java.io :as io])
  (:import [java.io File ByteArrayOutputStream]
           [javax.crypto KeyGenerator Cipher SecretKeyFactory]
           [javax.crypto.spec PBEParameterSpec PBEKeySpec]))

(def salt (byte-array (map byte [0x1 0x10 0x30 0x40 0x34 0x24 0x11 0x23])))
(def cnt 20)
(def algorithm "PBEWithMD5AndDES")

(defn password []
  (println "Enter password for encryption/decryption")
  (.readPassword (System/console)))

(defn gen-key []
  (let [keyspec (PBEKeySpec. (password))]
    (-> algorithm
         SecretKeyFactory/getInstance
         (.generateSecret keyspec))))

(defn process [data mode]
  (let [pbe-key (gen-key)
        spec (PBEParameterSpec. salt cnt)
        cipher (Cipher/getInstance algorithm)]
    (.init cipher mode pbe-key spec)
    (.doFinal cipher data)))

(defn encrypt [data]
  (process data Cipher/ENCRYPT_MODE))

(defn decrypt [data]
  (process data Cipher/DECRYPT_MODE))

(defn as-bytes [file]
  (let [os (ByteArrayOutputStream.)]
    (io/copy file os)
    (.toByteArray os)))

(defn main [args]
  (let [mode (first args)
        source (-> args second File.)
        target (-> args last File.)]
    (if (= mode "encrypt")
      (-> source as-bytes encrypt (io/copy target))
      (-> source as-bytes decrypt (io/copy target)))))

(main *command-line-args*)
