mconf-stats Cookbook
=================

Install Mconf-Stats, Mconf's log analizer and statistics generator.

Requirements
------------

Ubuntu 12.04

e.g.
#### packages
- `toaster` - mconf-stats needs toaster to brown your bagel.

Attributes
----------

e.g.
#### mconf-stats::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['mconf-stats']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### mconf-stats::default

Just include `mconf-stats` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[mconf-stats]"
  ]
}
```
