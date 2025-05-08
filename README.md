# Automatizovaný systém chytrého parkovacího domu
## Závěrečný projekt BPC-DE1

### Členové týmu
* **Martin Živný** (m-zivny) - návrh top-levelu, implementace modulu us_control
* **Vojtěch Šťastný** (256701) - logický návrh, návrh téma projektu, tvorba dokumentace
* **David Kaláb** (DKEBCZ) - implementace seg_control a modulů ze cvičení  
* **Tomáš Kneř** (knertom) - implementace led_control, tvorba dokumentace

### Obsah
[Abstrakt](#Abstrakt)

[Hardware](#Hardware)

[Software](#Software)

[Simulace](#Simulace)

[Praktická ukázka](#Praktická-ukázka)

[Závěr](#Závěr)



### Abstrakt
Tento projekt se zabývá návrhem a implementací systému pro měření vzdálenosti pomocí dvou externě připojených ultrazvukových senzorů a zobrazení naměřených hodnot na osmi vestavěných 7segmentových displejích vývojového kitu FPGA Nexys A7 50T. Celý systém je implementován v jazyce VHDL ve vývojovém prostředí Vivado. Projekt zahrnuje návrh řídicí logiky pro ultrazvukové senzory, která generuje spouštěcí signály a zpracovává přijaté echo signály pro určení vzdálenosti. Následně jsou naměřené vzdálenosti převedeny na číselnou formu a zobrazeny na 7segmentových displejích pomocí multiplexování. Během vývoje bylo zjištěno, že po přibližně pěti sekundách provozu dochází k zastavení měření. Analýza ukázala, že příčinou je pravděpodobně problém v řídicí logice modulu pro zpracování signálů ze senzorů, konkrétně v mechanismu spouštění měření a řízení stavového automatu. Tento abstrakt shrnuje cíle projektu, použité technologie a identifikovaný problém, který bude dále řešen pro zajištění spolehlivého a kontinuálního měření vzdálenosti.

### Hardware
#### Použitý Hardware
Pro náš projekt jsme použili vývojový FPGA kit Nexys A7 50T, dvojici ultrazvukových senzorů vzdálenosti HS-SR04 a z důvodů rozdílných úrovní logických signálu vývojové desky a senzorů také obousměrný převodník logické úrovně. Dále jsme použili Arduino UNO, jako zdroj 5V pro senzory.
![hw](https://github.com/user-attachments/assets/ea75325f-01d0-4f6b-a881-0d444ac850b0)

#### Zapojení
V následujícím schématu je znázorněno jak jsou senzory připojeny k FPGA.

#### Měření
![scope](https://github.com/user-attachments/assets/62840a5c-8e9b-4ab0-b882-ae49c31bd4ba)

### Software
#### Architektura
jak jsme přistupovali k návrhu

#### Moduly
CLOCK_ENABLE:
Tento modul pochází z počítačových cvičení a umožňuje generovat hodinový signál s upravenou periodou. Používáme dvě instance tohoto modulu, jednu pro řízení aktuálního stavu modulu US_CONTROL (měření, čtení echo, idle) a druhou pro řízení modulu SEG_CONTROL.

#### [US_CONTROL:](https://github.com/m-zivny/DE1-Projekt/blob/main/source/us_control.vhd)

Náš vlastní modul US_CONTROL se stará o komunikaci s ultrazvukovým senzorem HS-SR04. Vysílá pulz trigger a příjimá pulz echo. Násedně změří dobu trvání pulzu echo, ze které vypočítá vzdálenost překážky od senzoru. Dále tuto vzdálenost posílá na další zpracování do modulu SEG_CONTROL. V návrh používáme dvě instance tohoto modulu, pro každý senzor jednu.

#### [SEG_CONTROL:](https://github.com/m-zivny/DE1-Projekt/blob/main/source/us_control.vhd)

Tento modul jsme vytvořili tak, aby dokázal přijmout dva různé signály 10bitové signály obsahuzíjí vzdálenost z instancí modulů US_CONTROL a následně se stará o multiplexování jednolivých digitů 7segmentových displejů na desce Nexys A7 50T. Výstupem tohoto modulu je signál který se stará o samotné přepínání aktivního digitu a druhý signál obsahující binární vyjádření hodnotu kterou chceme zobrazovat na atkivním digitu. 

#### BIN2SEG:

Tento modul neupravený verze modulu který jsme používali na počítačových cvičeních. Stará se o to, že vezme binární signál s číselnou hodnotou z modulu SEG_CONTROL a převede ho na signál vhodný pro aktivací jednotlivých segmentů aktivního digitu 7segmentového displeje. 

#### LED_CONTROL:

Účelem tohoto modulu je ovládání signalizačních RGB LED na desce. Vstupem tohoto modulu je signál s hodnotou vzdálenosti změřenou ultrazvukovým senzorem a porovnávání s námi nastavenou úrovní. Je-li tato úroveň překročena (vzdálenost překáždy je větší než nastavená úrověň), LED svítí zelenou barvou (parkovací místo je volné), pokud je naopak vzdálenost menší (vzdálenost překážky je měnší než nastavená úroveň), svítí LED červenou barvou (parkovací místo je obsazeno). Používáme opět dvě instance tohoto modulu, každou pro jeden senzor.


#### Top level
![toplevel](https://github.com/user-attachments/assets/3f0d52c3-7c77-478b-8962-de6d3ec8b30f)




#### Simulace
Simulace modulu US_CONTROL:

Simulace modulu SEG_CONTROL:
![seg_control_tb](https://github.com/user-attachments/assets/1a4a7b75-4b2d-4927-a5be-d9e1152bba04)

Simulace modulu LED_CONTROL:

Simulace modulu TOP_LEVEL:

### Praktická ukázka
https://github.com/user-attachments/assets/3c3cfd26-f967-455a-bc51-f47ca1241e27


### Závěr
