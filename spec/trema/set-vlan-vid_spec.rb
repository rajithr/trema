# encoding: utf-8
#
# Copyright (C) 2008-2013 NEC Corporation
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#

require File.join(File.dirname(__FILE__), '..', 'spec_helper')
require 'trema'

describe SetVlanVid, '.new(vlan_id)', :type => 'actions' do
  subject { SetVlanVid.new(vlan_id) }

  context 'with vlan_id (1024)' do
    let(:vlan_id) { 1024 }

    describe '#vlan_id' do
      subject { super().vlan_id }
      it { is_expected.to eq(1024) }
    end
  end

  it_validates 'option is within range', :vlan_id, 1..4095

  context 'with vlan_id (1024)' do
    let(:vlan_id) { '1024' }
    it { expect { subject }.to raise_error(TypeError) }
  end

  context 'with vlan_id ([1024])' do
    let(:vlan_id) { [1024] }
    it { expect { subject }.to raise_error(TypeError) }
  end

  context 'when sending a Flow Mod with SetVlanVid' do
    let(:vlan_id) { 1024 }

    it 'should insert a new flow entry with action (mod_vlan_vid:1024)' do
      class TestController < Controller; end
      network do
        vswitch { datapath_id 0xabc }
      end.run(TestController) do
        controller('TestController').send_flow_mod_add(0xabc, :actions => subject)
        sleep 2
        expect(vswitch('0xabc').flows.size).to eq(1)
        expect(vswitch('0xabc').flows[0].actions).to eq('mod_vlan_vid:1024')
      end
    end
  end
end

### Local variables:
### mode: Ruby
### coding: utf-8-unix
### indent-tabs-mode: nil
### End:
