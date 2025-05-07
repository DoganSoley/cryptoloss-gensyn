![ewoOeVzl_400x400](https://github.com/user-attachments/assets/823eb796-85ca-438d-b9f5-136afad96e7e)

# Gensyn Node Kurulumu

# [Kurulum Videosu](https://youtu.be/jZIDwKNVwrU) 

# DİKKAT ! Videodaki kurulumdan sonra güncelleme geldi bazı yerler aynı değil videoda takılırsanız bu rehberi takip ederek kurabilirsiniz.Şuanda dedicated olarak çalışan sunucu [netcup](https://www.netcup.com/en/server/root-server)'daki RS 4000 G11 daha düşük sunucularda çalışmıyor dedicated olması şart, onda bile arada duruyor yeni güncellemeden sonra ekran kartı biraz şart gibi oldu.

## Sunucu Gereksinimleri

RAM : Minimum 16GB

CPU : Mininum 12cpu(dedicated) paylaşımlı cpu sunucularda şuan çalışmıyor.

Ubuntu 24.04

GPU : RTX 3090, RTX 4090, A100, H100 (en az 24gb vram ekran kartı)

NOT : Ödül verecekleri kesin değil, açıklanmış net bir teşvik henüz yok ödül verme ihtimallerine karşı kurulum yapıyoruz.

# ÖNEMLİ ! 

Sadece RAM veya CPU ile olmuyor bir süre sonra çöküyor model eğitimi olacağı için ekran kartı şart.Fiyatlar biraz yüksek fakat eğer kendi pc'nizde 24vram ve üzeri ekran kartı varsa [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) ile windows'un altına ubuntu yükleyerek kendi pc'nizde de bu nodeyi çalıştırabilirsiniz.(wsl ile ubuntu nasıl kurulur diye araştırın yanlış birşey yaparsanız pc'niz çökebilir her ihtimale karşı önemli verilerinizi yedekleyin)

GPU kiralamak isterseniz : [Quickpod](https://quickpod.io/), [Hyperbolic](https://app.hyperbolic.xyz/) sitelerini veya başka bir yer kullanabilirsiniz.

GPU Haricinde şimdilik [netcup](https://www.netcup.com/en/server/root-server) üzerindeki "RS 4000 G11" sunucusunda çökmeden çalışıyor isteyen ona kurmayı da deneyebilir.

![image](https://github.com/user-attachments/assets/12b288f4-0ff4-44e0-a9c2-08f2d2a2e5f9)


# Kurulum Adımları
 
Sunucuya bağlandıktan sonra :

Tek kod kurulum :

```
wget https://raw.githubusercontent.com/DoganSoley/cryptoloss-gensyn/refs/heads/main/script.sh && chmod +x script.sh && ./script.sh
```

Kurulum bittikten sonra :

![image](https://github.com/user-attachments/assets/79ae0b2b-c596-4df5-9aa8-69eefd604085)

```
screen -r gensyn
```
Görseldeki gibi sırasıyla y/a/0.5 yazın.

![image](https://github.com/user-attachments/assets/a7b47801-2ddc-4fa7-9420-edcb8e53dfc3)

">> Waiting for modal userData.json to be created..." yazısını gördükten sonra "CTRL + A + D" ile screen'den çıkın.

![image](https://github.com/user-attachments/assets/1e866785-d042-47de-87ed-2af91b23ca9a)

```
screen -r tunnel
```

tunnel screen'e girin ve url'yi kopyalayıp tarayıcıya yapıştırın 

![image](https://github.com/user-attachments/assets/26669260-5b17-4d6c-b5db-8cfa8a6fcb68)


Sonrasında "password" kısmına sunucu ip adresinizi girin ve "click to submit"e tıklayın.

![image](https://github.com/user-attachments/assets/89a36279-fc85-48be-bed1-cf9d81da12c0)


Login'e tıklayın.

![image](https://github.com/user-attachments/assets/518f930e-19bc-478f-9ea8-42e743bd1c54)

Buraya mail adresinizi girin.(google ile bağlanmayın çalışmıyor)

![image](https://github.com/user-attachments/assets/0e5703c3-cc40-4fb1-b607-9d4fd73562c2)

Daha sonra mailinize gelen kodu buraya yapıştırarak onaylayın.

![image](https://github.com/user-attachments/assets/d8cd7edb-f8ab-454c-8765-1d33db480d73)

Testnet'e kayıt yaptık.

![image](https://github.com/user-attachments/assets/d0749333-e127-4a5a-92e8-348ed9b3debb)


Terminal'e dönün "CTRL + A + D" ile tunnel screen'den çıkın ve tekrar "gensyn" screen'a girin.

![image](https://github.com/user-attachments/assets/0343650f-b069-44cd-9045-7ce1fbf542c6)

```
screen -r gensyn
```
Yüklemenin tamamlanmasını bekleyin ve çıkan Hugging Face sorusuna "N" yazıp enterlayın.

![image](https://github.com/user-attachments/assets/a17230dc-51d6-4d69-bfa2-313b6be1e9a3)


Bu şekilde bir ekran aldıysanız tamamdır Node ID ve Peer ID yazan kelimeleri bir yere kaydedin.

![image](https://github.com/user-attachments/assets/c387d10b-c1f7-44aa-9136-6399ca9e5523)


Peer ID'yi [buraya](https://gensyn-node.vercel.app/) yazarak rewards sayısınızı kontrol edebilirsiniz.

![image](https://github.com/user-attachments/assets/b60bb097-b3d0-4bf8-bdb1-431d3235dde9)

Node ID'niz ile de [buraya](https://dashboard.gensyn.ai/) yazarak kontrol edebilirsiniz.

![image](https://github.com/user-attachments/assets/322f2718-ce77-4536-b543-8dea4d946da6)


Son olarak "swarm.pem" dosyasını ve "temp-data" klasörünü yedekleyelim.

[Winscp](https://winscp.net/eng/download.php) uygulamasını açıyorum

![image](https://github.com/user-attachments/assets/779c1336-0256-4e76-96f8-ca21cceb3333)

Sunucu ip yazıyorum kullanıcı adı root ve sunucu şifremi yazıp oturum aç diyorum.

"rl-swarm" klasörüne çift tıklayıp giriyorum.

![image](https://github.com/user-attachments/assets/c41b4b7f-3d7a-4780-baf2-e20f43ef7f90)

"swarm.pem" dosyasını tutup bilgisayarımın masaüstüne atıyorum.

![image](https://github.com/user-attachments/assets/890a8174-d0e2-4350-93c9-bd0a74edcfbf)

Daha sonra "modal-login" klasörüne çift tıklayarak giriyorum.

![image](https://github.com/user-attachments/assets/c0f5ff19-f931-44b9-a8a2-70de75a5ce7a)

"temp-data" klasörünü de aynı şekilde tutup bilgisayarımın masaüstüne atıyorum.

![image](https://github.com/user-attachments/assets/97bf5d8d-f213-4098-8218-05f607256420)

işlemler bu kadar.


# Güncelleme kodu ;

Sunucuya bağlanıp direkt bu kodu girin

```
gelecek..
```

Yükleme bittikten sonra ;

```
screen -r gensyn
```

ile screen'a girin yüklemenin bitmesini bekleyin yine ilk kurulumdaki gibi Hugging Face Hub? diye soracak "N" yazıp enterlayın kendisi çalışmaya başlayacak "Peer ID" güncellemeden öncekiyle aynı olup olmadığını kontrol edin.Daha önce swarm.pem dosyasını ve temp-data klasörünü yedek almadıysanız yukardaki adımları takip ederek alabilirsiniz.

# Yararlı Kodlar :

Eğer screen içerisinde node çalışmadığını görürseniz "ctrl + c" ile durdurun ve aşağıdaki kodları sırasıyla yazarak tekrar çalıştırın.(ctrl + c yaptığınız screen kapanırsa "screen -ls" ile mevcut screen'ları kontrol edin eğer screen silinmişse "screen -S gensyn" ile yeni screen açın ya da screen zaten açık ama giremiyorsanız aşağıdaki screen düzeltme kodunu kullanın)

```
cd rl-swarm
```
```
python3 -m venv .venv && source .venv/bin/activate && ./run_rl_swarm.sh
```

Eğer screen'a giremiyorsanız "Attached" hatası alıyorsanız screen'i düzeltmek için ;

```
screen -d -r gensyn
```
