require 'parser_09'

describe 'convert_csv_values' do
  before do
    @in_csv = <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
EOS
  end

  context 'when type is not defined by JSON Schema' do
    it 'should return Sting values' do
      json_schema = {}  # 型検査用のJSON Schema定義なし

      out_data = [
        { id: '1', name: 'Sho Nakatani', weight: '65.2', around_30s: 'true' },
        { id: '2', name: 'Naoki Yaguchi', weight: '68.7', around_30s: 'false' }
      ]

      result = TypedCsv::convert_csv_values(@in_csv, json_schema)

      expect(result).to eq out_data
    end
  end

  context 'when type is defined by JSON Schema' do
    it 'should return Sting values when JSON Schema is passed' do
      json_schema = {
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

      out_data = [
        { id: 1, name: 'Sho Nakatani', weight: 65.2, around_30s: true },
        { id: 2, name: 'Naoki Yaguchi', weight: 68.7, around_30s: false }
      ]

      result = TypedCsv::convert_csv_values(@in_csv, json_schema)

      expect(result).to eq out_data
    end
  end
end
