require 'parser'

describe 'convert_csv_values' do
  let(:in_csv) { <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
EOS
  }
  let(:blank_csv) { <<'EOS'
id,name
,hello
2,
EOS
}

  let(:health_json_schema) {
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
  let(:array_simple_json_schema) {
    {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'integer' },
          name: { type: 'string' },
        }
      }
    }
  }
  let(:name_requiring_json_schema) {
    {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          id: { type: 'integer' },
          name: { type: 'string' },
          },
        required: ['name']
        }
      }
    }
  shared_examples 'should parse CSV with specified type' do
    it do
      result = TypedCsv::convert_csv_values(in_csv, json_schema)
      expect(result).to eq out_data
    end
  end

  shared_examples 'should parse blank CSV' do
    it do
      result = TypedCsv::convert_csv_values(blank_csv, json_schema)
      expect(result).to eq out_data
    end
  end

  shared_examples 'should raise error' do
    it do
      expect{ TypedCsv::convert_csv_values(blank_csv, json_schema)}.to raise_error
    end
  end

  context 'when blank csv is given' do
    context 'with no required col' do
      let(:json_schema) { array_simple_json_schema }
      let(:out_data) {
        [
          { id: nil, name: 'hello' },
          { id: 2, name: nil }
        ]
      }
      it_behaves_like 'should parse blank CSV'
    end
    context 'with name required' do
      let(:json_schema) { name_requiring_json_schema }
      let(:out_data) {
        [
          { id: nil, name: 'hello' },
          { id: 2, name: nil }
        ]
      }
      it_behaves_like 'should raise error'
    end
  end

  context 'when type is not defined by JSON Schema' do
    let(:json_schema) { {} }
    let(:out_data) {
      [
        { id: '1', name: 'Sho Nakatani', weight: '65.2', around_30s: 'true' },
        { id: '2', name: 'Naoki Yaguchi', weight: '68.7', around_30s: 'false' }
      ]
    }
    it_behaves_like 'should parse CSV with specified type'
  end

  context 'when type is defined by JSON Schema' do
    let(:json_schema) { health_json_schema }
    let(:out_data) {
      [
        { id: 1, name: 'Sho Nakatani', weight: 65.2, around_30s: true },
        { id: 2, name: 'Naoki Yaguchi', weight: 68.7, around_30s: false }
      ]
    }
    it_behaves_like 'should parse CSV with specified type'
  end
end
