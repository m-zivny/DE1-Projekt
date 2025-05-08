# Automatizovaný systém chytrého parkovacího domu
### Závěrečný projekt BPC-DE1

## Členové týmu
* **Martin Živný** (m-zivny) - návrh top-levelu, implementace modulu us_control
* **Vojtěch Šťastný** (256701) - logický návrh, návrh téma projektu, tvorba dokumentace
* **David Kaláb** (DKEBCZ) - implementace seg_control a modulů ze cvičení  
* **Tomáš Kneř** (knertom) - implementace led_control, tvorba dokumentace

## Obsah
* [Abstrakt](#Abstrakt)

* [Hardware](#Hardware)
   - [Použitý Hardware](#Použitý-Hardware)
   - [Zapojení](#Zapojení)
   - [Měření](#Měření)
* [Software](#Software)
   - [Architektura](#Architektura)
   - [Moduly](#Moduly)
   - [Simulace](#Simulace)

* [Praktická ukázka](#Praktická-ukázka)

* [Závěr](#Závěr)
* [Reference](#Reference)



## Abstrakt
Tento projekt se zabývá návrhem a implementací systému pro měření vzdálenosti pomocí dvou externě připojených ultrazvukových senzorů a zobrazení naměřených hodnot na šesti vestavěných 7segmentových displejích vývojového FPGA kitu Nexys A7-50T. Celý systém je implementován v jazyce VHDL. Projekt zahrnuje návrh řídicí logiky pro ultrazvukové senzory, která generuje spouštěcí signály TRIGGER a zpracovává přijaté signály ECHO pro určení vzdálenosti. Následně jsou naměřené vzdálenosti zobrazeny na 7segmentových displejích pomocí multiplexování a "obsazenost" parkovacího místa je signalizována pomocí změny barvy dvojice RGB LED. 

## Hardware
### Použitý Hardware
Pro náš projekt jsme použili vývojový FPGA kit Nexys A7-50T, dvojici ultrazvukových senzorů vzdálenosti HS-SR04 a z důvodů rozdílných úrovní logických signálu vývojové desky a senzorů také obousměrný převodník logické úrovně. Dále jsme použili Arduino UNO, jako zdroj 5V pro senzory.
![hw](https://github.com/user-attachments/assets/ea75325f-01d0-4f6b-a881-0d444ac850b0)

### Zapojení
V následujícím schématu je znázorněno jak jsou senzory připojeny k FPGA. Ke komunikaci se senzory využíváme port pro připojení externích periferií Pmod JD, kterým vývojový kit disponuje.
![zapojeniv2](https://github.com/user-attachments/assets/d6282096-7043-456d-971a-49907e19c370)

### Měření
Na obrazovce osciloskopu vidíme na kanálu č. 2 signál TRIG (zelený), který přivádíme na senzor a signál ECHO (žlutý) na kanálu č. 1, který jde ze senzoru na vstup FPGA.
![scope](https://github.com/user-attachments/assets/62840a5c-8e9b-4ab0-b882-ae49c31bd4ba)

## Software
### Architektura

Program byl rozdělen do jednotlivých modulů, z nichž každý má svou specifickou funkci. Cílem tohoto návrhu byla možnost jednoduché úpravy jednotlivých částí kódu.

### Moduly
#### [CLOCK_ENABLE:](https://github.com/m-zivny/DE1-Projekt/blob/main/source/clock_enable.vhd) 

Tento modul pochází z počítačových cvičení a umožňuje generovat hodinový signál s upravenou periodou. Používáme dvě instance tohoto modulu, jednu pro řízení aktuálního stavu modulu US_CONTROL (měření, čtení echo, idle) a druhou pro řízení modulu SEG_CONTROL.

#### [US_CONTROL:](https://github.com/m-zivny/DE1-Projekt/blob/main/source/us_control.vhd)

Náš vlastní modul US_CONTROL se stará o komunikaci s ultrazvukovým senzorem HS-SR04. Vysílá pulz trigger a příjimá pulz echo. Násedně změří dobu trvání pulzu echo, ze které vypočítá vzdálenost překážky od senzoru. Dále tuto vzdálenost posílá na další zpracování do modulu SEG_CONTROL. V návrhu používáme dvě instance tohoto modulu, pro každý senzor jednu.

#### [SEG_CONTROL:](https://github.com/m-zivny/DE1-Projekt/blob/main/source/us_control.vhd)

Tento modul jsme vytvořili tak, aby dokázal přijmout dva různé signály 10bitové signály obsahuzíjí vzdálenost z instancí modulů US_CONTROL a následně se stará o multiplexování jednolivých digitů 7segmentových displejů na desce Nexys A7-50T. Výstupem tohoto modulu je signál, který se stará o samotné přepínání aktivního digitu a druhý signál obsahující binární vyjádření hodnoty kterou chceme zobrazovat na aktivním digitu. 

#### [BIN2SEG:](https://github.com/m-zivny/DE1-Projekt/blob/main/source/bin2seg.vhd)

Neupravená verze modulu z počítačových cvičení. Převádí přijatý 4bitový signál na signály, které řídí segmenty aktivního digitu 7segmentového displeje.

#### [LED_CONTROL:](https://github.com/m-zivny/DE1-Projekt/blob/main/source/led_control.vhd)

Modul řídí RGB led která signalizuje obsazenost parkovacího místa. Vzdálenosti získává z modulu US_CONTROL. Používáme 2 instance tohoto modulu.


#### [TOP LEVEL:](https://github.com/m-zivny/DE1-Projekt/blob/main/source/top_level.vhd)
V modulu TOP_LEVEL propojujeme jednotlivé dílční moduly nebo jejich instance.
![toplevel](https://github.com/user-attachments/assets/3f0d52c3-7c77-478b-8962-de6d3ec8b30f)




### Simulace
#### [Simulace modulu US_CONTROL:](https://github.com/m-zivny/DE1-Projekt/blob/main/tb_source/tb_us_control.vhd)
![us_control_full](https://github.com/user-attachments/assets/cdfb0f8c-7eed-418b-a570-02c056111fc6)

Detail na impulz TRIGGER modulu US_CONTROL:
#### ![us_control_trig](https://github.com/user-attachments/assets/cecaf2dc-e2bb-43c8-ab27-d6e014c34728)

#### [Simulace modulu SEG_CONTROL:](https://github.com/m-zivny/DE1-Projekt/blob/main/tb_source/tb_seg_control.vhd)
![seg_control_tb](https://github.com/user-attachments/assets/1a4a7b75-4b2d-4927-a5be-d9e1152bba04)

#### [Simulace modulu LED_CONTROL:](https://github.com/m-zivny/DE1-Projekt/blob/main/tb_source/tb_led_control.vhd)
![led_control_tb](https://github.com/user-attachments/assets/fad83693-e4a4-488b-a4c1-c561e39b318f)

#### [Simulace modulu TOP_LEVEL:](https://github.com/m-zivny/DE1-Projekt/blob/main/tb_source/tb_top_level.vhd)
![top_level_tb](https://github.com/user-attachments/assets/567f1f05-7441-4c58-a727-89ecc57a99b5)

Detail na multiplexing displejů:
![top_level_multiplex](https://github.com/user-attachments/assets/d5138d27-0927-460f-ae1c-aa13ab3939b9)

## Praktická ukázka
https://github.com/user-attachments/assets/3c3cfd26-f967-455a-bc51-f47ca1241e27


## Závěr
I přes detailní analýzu testbenchů se nám nepodařilo bezchybně implementovat náš návrh. Celý systém se po pár sekundách zastaví na poslední změřené hodnotě. I přes veškeré debugování se nám nepodařilo tento problém vyřešit. 

## Reference
https://github.com/tomas-fryza/vhdl-labs

https://www.microcontrollertips.com/principle-applications-limitations-ultrasonic-sensors-faq/ 

https://digilent.com/reference/programmable-logic/nexys-a7/start

https://vhdl.lapinoo.net/
