require 'parser'

describe 'convert_csv_values' do
  let(:in_csv) { <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
,"hoge3",33.3,false
4,,44.4,true
5,"hoge5",,false
6,"hoge6",66.6,
EOS
  }

  shared_examples 'should parse CSV with specified type' do
    it do
      result = TypedCsv::convert_csv_values(in_csv, json_schema)
      expect(result).to eq out_data
    end
  end

  context 'when type is not defined by JSON Schema' do
    let(:json_schema) { {} }
    let(:out_data) {
      [
        { id: '1', name: 'Sho Nakatani',  weight: '65.2', around_30s: 'true' },
        { id: '2', name: 'Naoki Yaguchi', weight: '68.7', around_30s: 'false' },
        { id: nil, name: 'hoge3',         weight: '33.3', around_30s: 'false' },
        { id: '4', name: nil,             weight: '44.4', around_30s: 'true' },
        { id: '5', name: 'hoge5',         weight: nil,    around_30s: 'false' },
        { id: '6', name: 'hoge6',         weight: '66.6', around_30s: nil }
       ]
    }

    it_behaves_like 'should parse CSV with specified type'
  end

  context 'when type is defined by JSON Schema' do
    let(:json_schema) {
      {
        type: 'array',
        items: {
          type: 'object',
          properties: {
            id: { type: 'integer' },
            name: { type: 'string' },
            weight: { type: 'number' },
            around_30s: { type: 'boolean' }
          }
        }
      }
    }
    let(:out_data) {
      [
        { id: 1,   name: 'Sho Nakatani',  weight: 65.2, around_30s: true },
        { id: 2,   name: 'Naoki Yaguchi', weight: 68.7, around_30s: false },
        { id: nil, name: 'hoge3',         weight: 33.3, around_30s: false },
        { id: 4,   name: nil,             weight: 44.4, around_30s: true },
        { id: 5,   name: 'hoge5',         weight: nil,  around_30s: false },
        { id: 6,   name: 'hoge6',         weight: 66.6, around_30s: nil }
      ]
    }

    it_behaves_like 'should parse CSV with specified type'
  end
end
