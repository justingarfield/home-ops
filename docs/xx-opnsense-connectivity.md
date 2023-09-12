# OPNsense Firewall Connectivity

## Table of Contents

* [TBD](#)

## Physical Connectivity

```mermaid
flowchart LR
  L3Router[L3 Router]
  TORSwitch[TOR Switch]

  %% Firewall WAN ports to L3 Router
  L3Router-- CAT8 ---Fw1GbePort1
  L3Router-- CAT8 ---Fw2GbePort1

  %% Firewall Management ports to TOR Switch
  Fw1GbePort2-- CAT8 ---TORSwitch
  Fw2GbePort2-- CAT8 ---TORSwitch

  %% Firewall LAN Trunk ports to TOR Switch
  Fw1SFPPPort1-- TwinAX DAC ---TORSwitch
  Fw1SFPPPort2-- TwinAX DAC ---TORSwitch
  Fw2SFPPPort1-- TwinAX DAC ---TORSwitch
  Fw2SFPPPort2-- TwinAX DAC ---TORSwitch

  %% Firewall pfSync ports direct conections
  Fw1SFPPPort3-- TwinAX DAC ---Fw2SFPPPort3
  Fw1SFPPPort4-- TwinAX DAC ---Fw2SFPPPort4

  subgraph Firewall1
    Fw1GbePort1[Gbe Port 1]
    Fw1GbePort2[Gbe Port 2]
    subgraph Fw1IntelNIC[Intel 4-Port SFP+ NIC]
      Fw1SFPPPort1[SFP+ Port 1]
      Fw1SFPPPort2[SFP+ Port 2]
      Fw1SFPPPort3[SFP+ Port 3]
      Fw1SFPPPort4[SFP+ Port 4]
    end
  end

  subgraph Firewall2
    Fw2GbePort1[Gbe Port 1]
    Fw2GbePort2[Gbe Port 2]
    subgraph Fw2IntelNIC[Intel 4-Port SFP+ NIC]
      Fw2SFPPPort1[SFP+ Port 1]
      Fw2SFPPPort2[SFP+ Port 2]
      Fw2SFPPPort3[SFP+ Port 3]
      Fw2SFPPPort4[SFP+ Port 4]
    end
  end
```

| Device     | Connection | Purpose    | Description |
|-|-|-|-|
| Firewall 1 | CAT8       | Router     | 1Gbps CAT8 connection to Layer-3 Router |
| Firewall 1 | CAT8       | Management | 1Gbps CAT8 connection to TOR Switch |
| Firewall 1 | TwinAX DAC | LAN Trunk  | Two 10Gbit TwinAX DACs from 4-port Intel NIC to TOR Switch |
| Firewall 1 | TwinAX DAC | pfSync     | Two 10Gbit TwinAX DACs from 4-port Intel NIC to 4-port Intel NIC of 2nd Firewall |
| Firewall 2 | CAT8       | Router     | 1Gbps CAT8 connection to Layer-3 Router |
| Firewall 2 | CAT8       | Management | 1Gbps CAT8 connection to TOR Switch |
| Firewall 2 | TwinAX DAC | LAN Trunk  | Two 10Gbit TwinAX DACs from 4-port Intel NIC to TOR Switch |
| Firewall 2 | TwinAX DAC | pfSync     | Two 10Gbit TwinAX DACs from 4-port Intel NIC to 4-port Intel NIC of 1st Firewall |

## Layer-2 Connectivity

**WIP: Had to call it quits before finishing this one so far**

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%

flowchart LR
  L3Router[L3 Router]
  TORSwitch[TOR Switch]

  Fw1TorLacpLagg[LACP Active\nTrunk LAGG]
  Fw2TorLacpLagg[LACP Active\nTrunk LAGG]
  PfsyncTorLacpLagg[LACP Active\npfSync LAGG]

  %% Firewall WAN ports to L3 Router
  L3Router---Fw1GbePort1
  L3Router---Fw2GbePort1

  %% Firewall Management ports to TOR Switch
  Fw1GbePort2---TORSwitch
  Fw2GbePort2---TORSwitch

  %% Firewall LAN Trunk ports to TOR Switch
  Fw1SFPPPort1---Fw1TorLacpLagg
  Fw1SFPPPort2---Fw1TorLacpLagg
  Fw1TorLacpLagg---TORSwitch
  Fw1TorLacpLagg---TORSwitch

  Fw2SFPPPort1---Fw2TorLacpLagg
  Fw2SFPPPort2---Fw2TorLacpLagg
  Fw2TorLacpLagg---TORSwitch
  Fw2TorLacpLagg---TORSwitch

  Fw1SFPPPort3---PfsyncTorLacpLagg
  Fw1SFPPPort4---PfsyncTorLacpLagg
  PfsyncTorLacpLagg---Fw2SFPPPort3
  PfsyncTorLacpLagg---Fw2SFPPPort4

  subgraph Firewall1
    Fw1GbePort1[Gbe Port 1]
    Fw1GbePort2[Gbe Port 2]
    subgraph Fw1IntelNIC[Intel 4-Port SFP+ NIC]
      Fw1SFPPPort1[SFP+ Port 1]
      Fw1SFPPPort2[SFP+ Port 2]
      Fw1SFPPPort3[SFP+ Port 3]
      Fw1SFPPPort4[SFP+ Port 4]
    end
  end

  subgraph Firewall2
    Fw2GbePort1[Gbe Port 1]
    Fw2GbePort2[Gbe Port 2]
    subgraph Fw2IntelNIC[Intel 4-Port SFP+ NIC]
      Fw2SFPPPort1[SFP+ Port 1]
      Fw2SFPPPort2[SFP+ Port 2]
      Fw2SFPPPort3[SFP+ Port 3]
      Fw2SFPPPort4[SFP+ Port 4]
    end
  end
```

## Layer-3 Connectivity

**WIP: Had to call it quits before finishing this one so far**

```mermaid
%%{init: {"flowchart": {"defaultRenderer": "elk"}} }%%

flowchart LR
  style WanVip fill:#555,stroke-dasharray: 3 5
  L3Router[L3 Router]
  WanVip[WAN VIP]
  TORSwitch[TOR Switch]

  Fw1TorLacpLagg[LACP Active\nTrunk LAGG]
  Fw2TorLacpLagg[LACP Active\nTrunk LAGG]
  PfsyncTorLacpLagg[LACP Active\npfSync LAGG]

  %% Firewall WAN ports to L3 Router
  L3Router--Static IP---WanVip
  WanVip--Static IP---Fw1GbePort1
  WanVip--Static IP---Fw2GbePort1

  %% Firewall Management ports to TOR Switch
  Fw1GbePort2---TORSwitch
  Fw2GbePort2---TORSwitch

  %% Firewall LAN Trunk ports to TOR Switch
  Fw1SFPPPort1---Fw1TorLacpLagg
  Fw1SFPPPort2---Fw1TorLacpLagg
  Fw1TorLacpLagg---TORSwitch
  Fw1TorLacpLagg---TORSwitch

  Fw2SFPPPort1---Fw2TorLacpLagg
  Fw2SFPPPort2---Fw2TorLacpLagg
  Fw2TorLacpLagg---TORSwitch
  Fw2TorLacpLagg---TORSwitch

  Fw1SFPPPort3---PfsyncTorLacpLagg
  Fw1SFPPPort4---PfsyncTorLacpLagg
  PfsyncTorLacpLagg---Fw2SFPPPort3
  PfsyncTorLacpLagg---Fw2SFPPPort4

  subgraph Firewall1
    Fw1GbePort1[Gbe Port 1]
    Fw1GbePort2[Gbe Port 2]
    subgraph Fw1IntelNIC[Intel 4-Port SFP+ NIC]
      Fw1SFPPPort1[SFP+ Port 1]
      Fw1SFPPPort2[SFP+ Port 2]
      Fw1SFPPPort3[SFP+ Port 3]
      Fw1SFPPPort4[SFP+ Port 4]
    end
  end

  subgraph Firewall2
    Fw2GbePort1[Gbe Port 1]
    Fw2GbePort2[Gbe Port 2]
    subgraph Fw2IntelNIC[Intel 4-Port SFP+ NIC]
      Fw2SFPPPort1[SFP+ Port 1]
      Fw2SFPPPort2[SFP+ Port 2]
      Fw2SFPPPort3[SFP+ Port 3]
      Fw2SFPPPort4[SFP+ Port 4]
    end
  end
```
