require 'parser_04'

describe 'convert_csv_values' do
  it 'should return Sting values' do
    in_csv = <<'EOS'
id,name,weight,around_30s
1,"Sho Nakatani",65.2,true
2,"Naoki Yaguchi",68.7,false
EOS

    out_data = [
      { id: '1', name: 'Sho Nakatani', weight: '65.2', around_30s: 'true' },
      { id: '2', name: 'Naoki Yaguchi', weight: '68.7', around_30s: 'false' }
    ]

    result = TypedCsv::convert_csv_values in_csv

    expect(result).to eq out_data
  end
end
