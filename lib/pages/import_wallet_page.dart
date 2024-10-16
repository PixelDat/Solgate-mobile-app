import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tongate/widgets/GradientButton.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'package:bip39/bip39.dart' as bip39;
import 'package:ed25519_hd_key/ed25519_hd_key.dart';
import 'package:hex/hex.dart';
import 'package:web3dart/web3dart.dart';
import 'package:base58check/base58check.dart' as base58;
import 'package:tongate/widgets/CustomToast.dart';
import 'package:tongate/utils/toast_utils.dart';

class ImportWalletPage extends StatefulWidget {
  @override
  _ImportWalletPageState createState() => _ImportWalletPageState();
}

class _ImportWalletPageState extends State<ImportWalletPage> {
  final TextEditingController _recoveryPhraseController = TextEditingController();
  final _storage = FlutterSecureStorage();
  final _encryptionKey = encrypt.Key.fromLength(32); // Generate a secure key
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background elements
          Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/images/glow_background_1.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: -700,
            left: -900,
            child: Image.asset(
              'assets/images/background_top_left.png',
              width: 2200,
              height: 2200,
            ),
          ),
          Positioned(
            top: -10,
            left: -30,
            child: Image.asset(
              'assets/images/background_bottom_right.png',
              width: 300,
              height: 300,
            ),
          ),
          // Main content
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Import Wallet',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 40),
                        Text(
                          'Enter\nRecovery Phrase',
                          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Your recovery phrase has 12 or 24 words, enter the words in the correct order, divided with spaces.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF8A2BE2),
                                Color(0xFF4169E1),
                                Color(0xFF00CED1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          padding: EdgeInsets.all(1), // Thin border
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF1F1F3D),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  controller: _recoveryPhraseController,
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your recovery phrase',
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16),
                                  ),
                                ),
                                Divider(
                                  color: Colors.white24,
                                  height: 1,
                                ),
                                TextButton.icon(
                                  icon: Icon(Icons.copy_outlined, color: Colors.white70, size: 20),
                                  label: Text(
                                    'Paste phrase',
                                    style: TextStyle(color: Colors.white70, fontSize: 14),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    alignment: Alignment.center,
                                  ),
                                  onPressed: () async {
                                    ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
                                    if (clipboardData != null && clipboardData.text != null) {
                                      setState(() {
                                        _recoveryPhraseController.text = clipboardData.text!;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(24.0),
                  child: GradientButton(
                    onPressed: _isLoading ? () {} : _confirmWallet,
                    child: _isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text('Confirming...'),
                            ],
                          )
                        : Text('Confirm wallet', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmWallet() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recoveryPhrase = _recoveryPhraseController.text.trim();
      if (recoveryPhrase.isEmpty) {
        showCustomToast(context, 'Please enter a recovery phrase', ToastType.warning);
        return;
      }

      if (!bip39.validateMnemonic(recoveryPhrase)) {
        showCustomToast(context, 'Invalid recovery phrase', ToastType.error);
        return;
      }

      final solanaPrivateKey = await _generatePrivateKey(recoveryPhrase, blockchain: 'solana');
      final ethereumPrivateKey = await _generatePrivateKey(recoveryPhrase, blockchain: 'ethereum');
      final walletName = await _getNextWalletName();

      final wallet = {
        'wallet_name': walletName,
        'passphrase': _encrypt(recoveryPhrase),
        'solana_private_key': _encrypt(solanaPrivateKey),
        'ethereum_private_key': _encrypt(ethereumPrivateKey),
      };
      
      print(wallet);
      await _saveWallet(wallet);

      showCustomToast(context, 'Wallet imported successfully', ToastType.success);
      // TODO: Navigate to the next screen
    } catch (e) {
      showCustomToast(context, 'Error importing wallet: ${e.toString()}', ToastType.error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getNextWalletName() async {
    final walletsJson = await _storage.read(key: 'wallets') ?? '[]';
    final wallets = jsonDecode(walletsJson) as List;
    
    int index = 1;
    String walletName;
    do {
      walletName = 'Wallet $index';
      index++;
    } while (wallets.any((w) => w['wallet_name'] == walletName));

    return walletName;
  }

  Future<void> _saveWallet(Map<String, String> wallet) async {
    final walletsJson = await _storage.read(key: 'wallets') ?? '[]';
    final wallets = jsonDecode(walletsJson) as List;
    wallets.add(wallet);
    await _storage.write(key: 'wallets', value: jsonEncode(wallets));
  }

  Future<String> _generatePrivateKey(String recoveryPhrase, {String blockchain = 'solana'}) async {
    if (!bip39.validateMnemonic(recoveryPhrase)) {
      throw ArgumentError('Invalid mnemonic');
    }

    final seed = bip39.mnemonicToSeed(recoveryPhrase);

    String derivationPath;
    switch (blockchain.toLowerCase()) {
      case 'solana':
        derivationPath = "m/44'/501'/0'/0'";
        final keyData = await ED25519_HD_KEY.derivePath(derivationPath, seed);
        return base58.Base58CheckEncoder(keyData.key.toString()).toString();
      case 'ethereum':
        derivationPath = "m/44'/60'/0'/0/0";
        final masterKey = await ED25519_HD_KEY.getMasterKeyFromSeed(seed);
        final privateKey = HEX.encode(masterKey.key);
        final ethPrivateKey = EthPrivateKey.fromHex(privateKey);
        return ethPrivateKey.privateKey.toString();
      case 'bitcoin':
        derivationPath = "m/44'/0'/0'/0/0";
        throw UnimplementedError('Bitcoin key derivation not implemented');
      default:
        throw ArgumentError('Unsupported blockchain: $blockchain');
    }
  }

  String _encrypt(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
    final iv = encrypt.IV.fromLength(16);
    return encrypter.encrypt(data, iv: iv).base64;
  }

  String _decrypt(String encryptedData) {
    final encrypter = encrypt.Encrypter(encrypt.AES(_encryptionKey));
    final iv = encrypt.IV.fromLength(16);
    return encrypter.decrypt64(encryptedData, iv: iv);
  }
}