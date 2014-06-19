require 'parser_10'

describe 'convert_csv_values' do
  before do
    @in_csv = <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
EOS
  end

  shared_examples 'should parse CSV with specified type' do
    it do
      result = TypedCsv::convert_csv_values(@in_csv, @json_schema)
      expect(result).to eq @out_data
    end
  end

  context 'when type is not defined by JSON Schema' do
    before do
      @json_schema = {}
      @out_data = [
        { id: '1', name: 'Sho Nakatani', weight: '65.2', around_30s: 'true' },
        { id: '2', name: 'Naoki Yaguchi', weight: '68.7', around_30s: 'false' }
      ]
    end

    it_behaves_like 'should parse CSV with specified type'
  end

  context 'when type is defined by JSON Schema' do
    before do
      @json_schema = {
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

      @out_data = [
        { id: 1, name: 'Sho Nakatani', weight: 65.2, around_30s: true },
        { id: 2, name: 'Naoki Yaguchi', weight: 68.7, around_30s: false }
      ]
    end

    it_behaves_like 'should parse CSV with specified type'
  end
end
