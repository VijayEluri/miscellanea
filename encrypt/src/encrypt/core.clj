(ns encrypt.core
  (:require [clojure.java.io :as io])
  (:import [java.io File ByteArrayOutputStream]
           [javax.crypto Cipher SecretKeyFactory]
           [javax.crypto.spec PBEParameterSpec PBEKeySpec]
           (java.lang.reflect Type)))

(def salt (byte-array (map byte [0x1 0x10 0x30 0x40 0x34 0x24 0x11 0x23])))
(def cnt 20)
(def algorithm "PBEWithMD5AndDES")

(def ^:dynamic ^String password)

(defn gen-key []
  (let [keyspec (PBEKeySpec. (char-array password))]
    (-> algorithm
        SecretKeyFactory/getInstance
        (.generateSecret keyspec))))

(defn run-cipher [data mode]
  (let [pbe-key (gen-key)
        spec (PBEParameterSpec. salt cnt)
        cipher (Cipher/getInstance algorithm)]
    (.init cipher mode pbe-key spec)
    (.doFinal cipher data)))

(defn encrypt-bytes [^bytes data]
  (run-cipher data Cipher/ENCRYPT_MODE))

(defn decrypt-bytes [^bytes data]
  (run-cipher data Cipher/DECRYPT_MODE))

(defn as-bytes [^File file]
  (let [os (ByteArrayOutputStream.)]
    (io/copy file os)
    (.toByteArray os)))

(defn encrypt
  [^String src-path ^String dst-path]
  (let [src (File. src-path)
        dst (File. dst-path)]
    (-> src as-bytes encrypt-bytes (io/copy dst))))

(defn decrypt
  [^String src-path ^String dst-path]
  (let [src (File. src-path)
        dst (File. dst-path)]
    (-> src as-bytes decrypt-bytes (io/copy dst))))
